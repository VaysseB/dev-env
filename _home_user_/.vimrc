"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=en_UK
let $lang='en_UK'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GVim only
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set guifont=Liberation\ Mono:h9
set t_Co=256


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

colorscheme ron

set background=light
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set number

" Split row, command mode
map m i<C-m><ESC>l

" Search what is selected in visual mode with '//'
" (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
vnoremap <expr> // 'y/\V'.escape(@",'\').'<CR>'

" Fill replace ex with word under the cursor with '\s'
" Match only word, not any sequence made of it
" global to the file
" http://vim.wikia.com/wiki/VimTip464
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>

" Code
" folding
set foldmethod=indent
set foldlevel=99
nnoremap Q za

" Python - PEP8
autocmd BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set encoding=utf-8

" Web
autocmd BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set encoding=utf-8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keyboard trick
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function s:caps_as_escape ()
    if has('unix')
        silent execute '!setxkbmap' '-option' 'caps:escape'
    else
        silent execute '!reg' 'add' 'HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout' '/v' 'Scancode Map' '/t' 'REG_BINARY' '/d' '00000000000000000200000001003a0000000000'
    endif
endfunction

function s:reset_caps ()
    if has('unix')
        silent execute '!setxkbmap' '-option'
    else
        silent execute '!reg' 'delete' 'HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout' '/v' 'Scancode Map'
    endif
endfunction

autocmd VimEnter * :call s:caps_as_escape()
autocmd VimLeave * :call s:reset_caps()
autocmd FocusGained * :call s:caps_as_escape()
autocmd FocusLost * :call s:reset_caps()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
" autocmd BufWrite *.py :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''

""""""""""
" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

"""""""""""""""
" YouCompleteMe
" https://github.com/Valloric/YouCompleteMe
"let g:ycm_rust_src_path="/home/v/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

""""""""""
" NERDtree
" https://github.com/scrooloose/nerdtree
nmap <silent> <C-t> :NERDTreeToggle<CR>
nmap <silent> <leader>r :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\~$']

"""""""""""""""
" NERDCommenter
" https://github.com/scrooloose/nerdcommenter

""""""""""
" vim-autoformat
" https://github.com/Chiel92/vim-autoformat
let g:formatter_yapf_style='pep8'

""""""""
" Bclose
" http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
let b:bclose_multiple=0

""""""""
" LightLine
" https://github.com/itchyny/lightline.vim
set laststatus=2
let g:lightline = { 'colorscheme': 'wombat' }

""""""""
" Vim-Unimpaired
" https://github.com/tpope/vim-unimpaired
" Single line
nmap <C-Up> [e
nmap <C-Down> ]e
" Multi-lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

""""""""
" Vim-racer for RLS (rust)
" https://github.com/rust-lang-nursery/rls
" https://github.com/racer-rust/vim-racer
" set hidden
" let g:racer_cmd="/home/v/.cargo/bin/racer"
" let g:racer_experimental_completer=1

""""""""
" Vim-Easy-Align
" https://github.com/junegunn/vim-easy-align
"Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
