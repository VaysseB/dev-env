# Development files and settings


## User folder

### Existing

1. conkyrc (require Conky)
1. default face (used by desktop)


## Bash

### Existing

1. bash_aliases + bash_profile:
    + `save_content` -> manage &lt;folder&gt;/_save/saveX
    + `grep_all` + `replace_all` -> find and replace in files by expression
    + others...


## Git

Version: 2.13.3

### Existing

1. Aliases:
    + Misc: `st`, `co`, `br`, `rs`, `uptags`, `downtags`, `ci`, `find`
    + Complete yet compressed log: `lg`
    + Latest commit shorthand: `latest`
1. Editor: vim

### To modify on installation

1. Modify `user.name` and `user.email`.


## Vim

Version: 8.0

### Existing

1. Default config: _vimrc_
2. Extension manager: Pathogen
3. Plugins/Bundle: bclose, python identatation, NERDTree, NERDCommenter, vim-autoformat, vim-numbertoggle

### To install

1. YouCompleteMe
2. Rust.vim


## Tmux

Version: 2.5

### Existing

1. Predix: `<C-a>`
1. Bindings:
    + `<prefix>r`: reload user conf (require `~/.tmux.conf`)
    + `<prefix><C-s>`: synchronise panes
    + `<prefix>` + `h` `j` `k` `l`: move between panes
1. Window & Pane base index is 1
1. Monitor and visual activity enabled
1. Vi bindings for buffer mode

### Layout

1. Development layout: `dev.tmux.conf` (require `~/.tmux.conf`)