"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin indent on

""""""""""
" pathogen
execute pathogen#infect()
syntax on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Security / Best practices
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Up> :echo 'Arrow key disabled'<CR>
nnoremap <Down> :echo 'Arrow key disabled'<CR>
nnoremap <Left> :echo 'Arrow key disabled'<CR>
nnoremap <Right> :echo 'Arrow key disabled'<CR>
vnoremap <Up> :echo 'Arrow key disabled'<CR>
vnoremap <Down> :echo 'Arrow key disabled'<CR>
vnoremap <Left> :echo 'Arrow key disabled'<CR>
vnoremap <Right> :echo 'Arrow key disabled'<CR>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
if has("gui_running")
  if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Liberation\ Mono\ 9
  elseif has("gui_photon")
    set guifont=Liberation\ Mono:h9
  else
    set guifont=Liberation_Mono:h9
  endif

  set lines=42
  set columns=142
endif


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

colorscheme desert

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

set listchars=eol:$,tab:>-,trail:#,nbsp:%,extends:>,precedes:<
set nolist

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader commands and shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Small life savior
vmap qq <ESC>
imap qq <ESC>

" Pinky savior
let mapleader = ' '

" Start-up settings
" Open / Edit VIMRC
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
" Source / Reload VIMRC
nnoremap <leader>sv :source $MYVIMRC<CR>

" Fast commands
nnoremap <leader>w :w<CR>
nnoremap <leader>W :w!<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>

" Insert a line above the cursor, do not update indentation of current line
nnoremap <leader>t mzO<ESC>`z

" Insert a line below the cursor
nnoremap <leader>h mzA<CR><ESC>`z

" Split row at cursor, with past-cursor as new line indented 
nnoremap <leader>m i<C-m><ESC>l

" Fill replace ex with word under the cursor with '\s'
" Match only word, not any sequence made of it
" global to the file
" http://vim.wikia.com/wiki/VimTip464
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>
nnoremap <leader>S :%s/\<<C-r><C-w>\>//g<Left><Left>

" Open explorer at file folder
nnoremap <leader>e :Explore "expand('%:p:h')"<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Clear highlighting until next search
nnoremap <C-l> :noh<CR><C-l>

" Toggle visibility of whitespaces
function! ToggleWhitespaceVisibility()
    if !exists("g:toggle_ws_visible")
        let g:toggle_ws_visible = 1
    endif
    
    if g:toggle_ws_visible == 1
        execute("silent set list")
        let g:toggle_ws_visible = 0
    else
        execute("silent set nolist")
        let g:toggle_ws_visible = 1
    endif
endfunction
command! ToggleWS call ToggleWhitespaceVisibility()
nnoremap <silent> <C-s> :ToggleWS<CR>

" Uppercase in insert mode
inoremap <C-u> <ESC>mzgUiw`za
" Lowercase in insert mode
inoremap <C-l> <ESC>mzguiw`za

" Search what is selected in visual mode with '//'
" (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
vnoremap <expr> // 'y/\V'.escape(@",'\').'<CR>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Code prettier
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Folding
set foldmethod=indent
set foldlevel=99

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
autocmd BufNewFile,BufRead *.vue setfiletype html
autocmd BufNewFile,BufRead *.jsm,*.jsx setfiletype javascript
autocmd BufNewFile,BufRead *.js,*.html,*.css,*.vue,*.ts,*.json
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set encoding=utf-8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keyboard trick
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func! s:caps_as_escape ()
    if has('unix')
        silent execute '!setxkbmap' '-option' 'caps:escape'
    else
        silent execute '!reg' 'add' 'HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout' '/v' 'Scancode Map' '/t' 'REG_BINARY' '/d' '00000000000000000200000001003a0000000000'
    endif
endfunc

func! s:reset_caps ()
    if has('unix')
        silent execute '!setxkbmap' '-option'
    else
        silent execute '!reg' 'delete' 'HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout' '/v' 'Scancode Map'
    endif
endfunc

" autocmd VimEnter * :call s:caps_as_escape()
" autocmd VimLeave * :call s:reset_caps()
" autocmd FocusGained * :call s:caps_as_escape()
" autocmd FocusLost * :call s:reset_caps()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py,*.cpp,*.h,*.js,*.css,*.html,*.vue,*.json,*.ts :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''

""""""""""
" netrw
let g:netrw_liststyle = 3 " tree-view
let g:netrw_banner = 0    " hide banner


"""""""""""""""
" YouCompleteMe
" https://github.com/Valloric/YouCompleteMe
"let g:ycm_rust_src_path="/home/v/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

""""""""""
" NERDtree
" https://github.com/scrooloose/nerdtree
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <leader>r :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__']

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
nnoremap <leader>b :Bclose<CR>
vnoremap <leader>b :Bclose<CR>

""""""""
" LightLine
" https://github.com/itchyny/lightline.vim
set laststatus=2
let g:lightline = { 'colorscheme': 'wombat' }

""""""""
" Vim-Unimpaired
" https://github.com/tpope/vim-unimpaired
" Single line
nnoremap <C-Up> [e
nnoremap <C-Down> ]e
" Multi-lines
vnoremap <C-Up> [egv
vnoremap <C-Down> ]egv

""""""""
" Vim-racer for RLS (rust)
" https://github.com/rust-lang-nursery/rls
" https://github.com/racer-rust/vim-racer
" set hidden
" let g:racer_cmd="/home/v/.cargo/bin/racer"
" let g:racer_experimental_completer=1

""""""""
" Vim-Easy-Align
" Tabular/Column alignement
" https://github.com/junegunn/vim-easy-align
"Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)

"""""""
" Vim-Abolish
" Change cases (MixedCase, snake_case, UPPER_CASE...)
" https://github.com/tpope/vim-abolish/blob/master/plugin/abolish.vim
let g:abolish_save_file=expand("/dev/null")

"""""""
" MPage
" https://github.com/vim-scripts/MPage

"""""""
" Session Man
" https://github.com/vim-scripts/sessionman.vim
let g:sessionman_save_on_exit=0

"""""""
" CtrlP
" Fuzzy file search
" https://github.com/ctrlpvim/ctrlp.vim.git
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v([\/]\.(git|hg|svn)|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|suo|opensdf|sdf|vspscc|filters)$',
  \ }
let g:ctrlp_root_markers = [ '\v\.sln' ]

"""""""
" CppDev (Own plugin)
nnoremap <silent> <leader>tt :ToggleHS<CR>
vnoremap <silent> <leader>tt :ToggleHS<CR>
