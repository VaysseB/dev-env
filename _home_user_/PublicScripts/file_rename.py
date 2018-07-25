#!/usr/bin/env python3

import os
import pathlib
import argparse
import re
import collections
import string
import json
import logging
import logging.config


DEBUG_MATCH = False
DEBUG_EXPAND = False


logging.config.dictConfig(dict(
    version=1,
    formatters={
        "f_console": { "format": "%(message)s" }
    },
    handlers={
        "h_console": {
            "class": "logging.StreamHandler",
            "formatter": "f_console",
            "level": logging.DEBUG
        }
    },
    root={
        'handlers': ['h_console'],
        'level': logging.DEBUG
    }
))
logger = logging.getLogger(__name__)


def join_str(args) -> str:
    if isinstance(args, str):
        return args
    return "".join(join_str(x) for x in args)


class NameFormatter(string.Formatter):
    def __init__(self):
        super().__init__()
        self.to_underscore_re = re.compile("[-._ \t\n\v]+")


    def check_unused_args(self, used_args, args, kwargs):
        assert args == ()
        missing = (key
                   for key in used_args
                   if kwargs.get(key) is None)
        for m in missing:
            raise KeyError(m)


    def convert_field(self, value: str, spec: str):
        if spec == "c":
            return (value or '').capitalize()
        elif spec == "w":
            return self.to_underscore_re.sub("_", value or '').strip()
        elif spec == "t":
            parts = self.to_underscore_re.split((value or '').strip())
            return '_'.join(x.capitalize() for x in parts)
        return super().convert_field(value, spec)


class Source:
    def __init__(self):
        self.scan_exprs = ()
        self.replace = {}
        self.rename_exprs = ()


    @staticmethod
    def load_all(fd):
        for blob in json.load(fd):
            source = Source()
            source._load(blob)
            yield source


    def _load(self, blob):
        self.replace = blob["replace"]
        self.rename_exprs = tuple(join_str(x) for x in blob["rename"])
        self.scan_exprs = []
        try:
            for parts in blob["scan"]:
                pattern = join_str(parts)
                self.scan_exprs.append(re.compile(pattern))
        except re.error as error:
            logger.error("Cannot compile '{}'".format(pattern))
            raise error


class SourceFinder:
    PATTERN = "*.flrnconf.json"
    CONFS_FOLDER = ".flrnconfs"

    def __init__(self):
        self.sources = []
        srcpath = pathlib.Path(__file__).resolve().parent
        self._load(srcpath.glob(self.PATTERN))
        self._load((srcpath / self.CONFS_FOLDER).glob(self.PATTERN))


    def _load(self, paths: [pathlib.Path]):
        for path in paths:
            with path.open('r') as file_:
                self.sources.extend(Source.load_all(file_))


    def find(self, path: pathlib.Path) -> (Source, dict):
        for source in self.sources:
            for expr in source.scan_exprs:
                matched = expr.match(path.name)
                if matched:
                    if DEBUG_MATCH:
                        logger.debug("Match '{}' with {}  ->  {}".format(
                            path.name,
                            expr.pattern,
                            matched.groupdict()))

                    return (source, matched.groupdict())
                elif DEBUG_MATCH:
                    logger.debug("Mismatch '{}' with '{}'".format(
                        path.name, expr.pattern))
        return (None, None)


def try_rename(patterns: [str], infos: dict) -> str:
    nf = NameFormatter()
    for expr in patterns:
        if DEBUG_EXPAND:
            logger.debug("try expand '{}' with {}".format(expr, infos))
        try:
            return nf.vformat(expr, (), infos)
        except KeyError:
            continue


def unformat_key_part(key: str) -> str:
    tail_i = key.rfind('_')
    if tail_i < 0:
        return key

    tail: str = key[tail_i+1:]
    if not tail.isdigit():
        return key

    return key[:tail_i]


def merge_parts(infos: dict) -> str:
    res = collections.defaultdict()
    res.default_factory = lambda: ''
    for key, value in infos.items():
        res[unformat_key_part(key)] += value if value else ''
    return dict(res)


def compose(source: Source, infos: dict) -> str:
    infos = merge_parts(infos)

    for key in source.replace:
        if key in infos:
            value = infos[key]
            infos[key] = source.replace[key].get(value, value)

    return try_rename(source.rename_exprs, infos)


def scan(paths: [pathlib.Path]) -> pathlib.Path():
    yield from (file_
                for root in paths
                for file_ in root.iterdir()
                if file_.is_file())


class RenamePolicy:
    def __init__(self, args):
        self.always_confirm = args.confirm
        self.dry_run = args.dry_run


    def rename(self, path: pathlib.Path, target: str):
        target = path.parent / target
        if not self.ask(path, target):
            return
        elif not self.dry_run:
            path.rename(target)


    def ask(self, path: pathlib.Path, target: pathlib.Path):
        if self.dry_run or self.always_confirm:
            return True
        elif target.exists():
            question = f"File already exists, replace (y/N/q) ?"
        else:
            question = f"Replace (Y/n/q) ? "

        answer = input(question)
        while answer and answer.lower() not in 'ynq':
            answer = input(f"Bad answer, retry.\n{question}")
        if answer in ('q', 'Q'):
            exit(0)
        return answer in ('y', 'Y')


def main(args):
    global DEBUG_MATCH, DEBUG_EXPAND

    DEBUG_MATCH = args.debug_match
    DEBUG_EXPAND = args.debug_expand
    logger.setLevel(logging.DEBUG if args.debug else logging.INFO)

    policy = RenamePolicy(args)
    sources = SourceFinder()

    for candidate in scan(args.folders):
        source, infos = sources.find(candidate)
        if not source:
            if args.skipped:
                logger.info(f"Skipped '{candidate}'")
        else:
            target = compose(source, infos)
            if target == candidate.name:
                continue

            logger.info(f"Rename '{candidate.name}' to '{target}'")
            policy.rename(candidate, target)


def cmd_args():
    pargs = argparse.ArgumentParser(
        description="Rename files based on predifined rules.",
        allow_abbrev=False)

    pargs.add_argument(
        "folders",
        help="Folder to applicate",
        metavar="path",
        default=("",),
        nargs="*")

    pargs.add_argument(
        "-n",  "--dry-run",
        help="Never confirm rename",
        action="store_true")

    pargs.add_argument(
        "-y", "--confirm",
        help="Always confirm rename. Use with cautious",
        action="store_true")

    pargs.add_argument(
        "--skipped",
        help="Show skipped file",
        action="store_true")

    pargs.add_argument(
        "--debug",
        help="Show all debug info",
        action="store_true")

    pargs.add_argument(
        "--debug-match",
        help="Show debug matching info",
        action="store_true")

    pargs.add_argument(
        "--debug-expand",
        help="Show debug expanding info",
        action="store_true")

    pargs.add_argument(
        "--cmp",
        help="Show file testing",
        action="store_true")

    args = pargs.parse_args()
    args.folders = tuple(pathlib.Path(x).resolve()
                         for x in args.folders)

    if args.debug:
        args.debug_match = args.debug_expand = args.debug
    else:
        args.debug |= args.debug_match or args.debug_match

    return args


if __name__ == "__main__":
    args = cmd_args()
    main(args)
