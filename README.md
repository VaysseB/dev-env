# Development files and settings


## User folder

### Existing

1. `conkyrc` (require Conky)
1. `.face` (used by desktop)


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
1. Editor: `vim`

### To modify on installation

1. Modify `user.name` and `user.email`.


## Vim

Version: 8.0

### Existing

1. Default config: `vimrc`
2. Extension manager: `Pathogen`
3. Plugins/Bundle: `bclose`, python indentation, `NERDTree`, `NERDCommenter`, `vim-autoformat`, `vim-numbertoggle`, `lightline`, `vim-unimpaired`
4. Bindings:
    + `<C-t>`: toggle NERDTree
    + `<leader>r`: find current in NERDTree
    + `<leader>s`: replace word under the cursor
    + VISUAL MODE + `m`: split row at new line
    + VISUAL MODE + `//`: find word
    + `G`: toggle folding
    + `<C-Up>`, `<C-Down>`: bubble rows

### To install

1. Bundle `YouCompleteMe`
2. Bundle `Rust.vim`


## Tmux

Version: 2.5

### Existing

1. Predix: `<C-a>`
1. Bindings:
    + `<prefix>r`: reload user conf (require `~/.tmux.conf`)
    + `<prefix><C-s>`: synchronise panes
    + `<prefix>` + `h` `j` `k` `l`: move between panes
    + others...
1. Window & Pane base index is 1
1. Monitor and visual activity enabled
1. Vi bindings for buffer mode

### Layout

1. Development layout: `dev.tmux.conf` (require `~/.tmux.conf`)