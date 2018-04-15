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


logging.config.dictConfig(dict(
    version=1,
    formatters={
        "f_console": { "format": "%(message)s" }
    },
    handlers={
        "h_console": {
            "class": "logging.StreamHandler",
            "formatter": "f_console",
            "level": logging.INFO
        }
    },
    root={
        'handlers': ['h_console'],
        'level': logging.INFO
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
            return (value or '').replace(" ", "_").strip()
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
        self.scan_exprs = tuple(re.compile(join_str(x)) for x in blob["scan"])
        self.rename_exprs = tuple(join_str(x) for x in blob["rename"])


class SourceFinder:
    PATTERN = "*.flrnconf.json"
    CONFS_FOLDER = ".flrnconfs"

    def __init__(self, _args):
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
                    return (source, matched.groupdict())
        return (None, None)


def try_rename(patterns: [str], infos: dict) -> str:
    nf = NameFormatter()
    for expr in patterns:
        try:
            return nf.vformat(expr, (), infos)
        except KeyError:
            continue


def compose(source: Source, infos: dict) -> str:
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
        self.no_confirm = args.no_confirm
        self.dry_run = args.dry_run


    def rename(self, path: pathlib.Path, target: str):
        target = path.parent / target
        if not self.ask(path, target):
            return
        elif not self.dry_run:
            path.rename(target)


    def ask(self, path: pathlib.Path, target: pathlib.Path):
        if self.dry_run or self.no_confirm:
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
    policy = RenamePolicy(args)
    sources = SourceFinder(args)

    for candidate in scan(args.folders):
        source, infos = sources.find(candidate)
        if not source:
            if args.skipped:
                logger.info(f"Skipped '{candidate}'")
        else:
            target = compose(source, infos)
            logger.info(f"Rename '{candidate.name}' to '{target}'")
            policy.rename(candidate, target)


def cmd_args():
    pargs = argparse.ArgumentParser(
        description="Rename files based on predifined rules.")

    pargs.add_argument(
        "folders",
        help="Folder to applicate",
        metavar="path",
        default=("",),
        nargs="*")

    pargs.add_argument(
        "--dry-run",
        help="Dry run. Output actions to make without doing them.",
        action="store_true")

    pargs.add_argument(
        "--no-confirm",
        help="Do not ask to confirm rename. Use with cautious.",
        action="store_true")

    pargs.add_argument(
        "--skipped",
        help="Output skipped file.",
        action="store_true")

    args = pargs.parse_args()
    args.folders = tuple(pathlib.Path(x).resolve()
                         for x in args.folders)
    return args


if __name__ == "__main__":
    args = cmd_args()
    main(args)
