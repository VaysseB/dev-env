"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin indent on

" Enable bundle and plugin load
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
" => Files extension by groups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:source_g1_exts = [ "py", "rs", "vimrc" ]
let g:source_g2_exts = [ "c", "cpp", "h", "hpp", "java", "yml", "yaml" ]
let g:source_web_exts = [ "css", "sass", "scss", "vue", "js", "jsx", "html", "ts", "json" ]
let g:source_g1_exts_str = "*." . join(g:source_g1_exts, ",*.")
let g:source_g2_exts_str = "*." . join(g:source_g2_exts, ",*.")
let g:source_web_exts_str = "*." . join(g:source_web_exts, ",*.")
let g:source_exts_str = g:source_g1_exts_str
            \ . "," . g:source_g2_exts_str
            \ . "," . g:source_web_exts_str

let g:tmp_build_exts = [ "*.o", "*~", "*.pyc", "*.pyo", "*.rslib" ]
let g:tmp_build_exts_str = join(g:tmp_build_exts, ",")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ignore compiled files
set wildignore=g:tmp_build_exts_str

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

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
" Numbers of colors
set t_Co=256

" Font and font size
if has("gui_running")
  if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Liberation\ Mono\ 9
  elseif has("gui_photon")
    set guifont=Liberation\ Mono:h9
  else
    set guifont=Liberation_Mono:h9
  endif

  " Default size
  set lines=42
  set columns=142
endif

" Warning column (80th) and Error column (120th)
if exists('+colorcolumn')
  highlight ColorColumn ctermbg=lightgrey guibg=#8c7269
  execute "autocmd BufNewFile,BufRead " . g:source_exts_str 
              \ " let &colorcolumn='80,'.join(range(120,999),',')"
endif

" Enable syntax highlighting
syntax enable

" Set theme
colorscheme desert

if has("neovim")
    set termguicolors
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Anti-loss of work
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off on save
set nobackup
set nowb

" Turn swap file on because mistake can happen (and did !)
set swapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UTF8 is life
set encoding=utf8

" Use Unix as the standard file type
set fileformat=unix
set fileformats=unix,dos,mac

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab <=> 4 spaces (by default)
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" Indent
set autoindent
set smartindent

" Enable soft wrap
set wrap

" Show line numbers
set number

" Whitespace visible chars
set listchars=eol:$,tab:>-,trail:#,nbsp:%,extends:>,precedes:<

" Hide whitespace
set nolist

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader commands and shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Small life savior
vmap qq <ESC>
imap qq <ESC>

" Pinky savior - can be used with both hands !
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

" Web ext reinterpretation
autocmd BufNewFile,BufRead *.vue setfiletype html
autocmd BufNewFile,BufRead *.jsm,*.jsx setfiletype javascript

" PEP8 style
execute "autocmd BufNewFile,BufRead " . g:source_g1_exts_str . "
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79"

" Other sources
execute "autocmd BufNewFile,BufRead " . g:source_g2_exts_str . ",". g:source_web_exts_str . "
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

autocmd BufWrite g:source_exts_str :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""''
"                   ###  SUMMARY  ###
"                    
"                    --- Visual ---
"
" lightline        ⇒ Improved Vim status line
"   https://github.com/itchyny/lightline.vim
"
" Vim-numbertoggle ⇒ Relative line numbering
"   https://github.com/jeffkreeftmeijer/vim-numbertoggle
"
" MPage            ⇒ Synchronized pages of a buffer
"   https://github.com/vim-scripts/MPage
"
"
"                  --- Filesystem ---
"
" ctrl-p           ⇒ Fuzzy file search
"   https://github.com/ctrlpvim/ctrlp.vim.git
"
" NERDtree         ⇒ Tree explorer of filesystem
"   https://github.com/scrooloose/nerdtree
"
"
"                    --- Editing ---
"
" NERDCommenter    ⇒ Comment support
"   https://github.com/scrooloose/nerdcommenter
" 
" Bclose           ⇒ Buffer closing without saving
"   http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
" 
" Vim-Unimpaired   ⇒ Selection move, str/url/xml encode/decode
"   https://github.com/tpope/vim-unimpaired
" 
" Vim-Easy-Align   ⇒ Tabular/Column alignement
"   https://github.com/junegunn/vim-easy-align
"
" Vim-surround     ⇒ Quoting/parenthesizing
"   https://github.com/tpope/vim-surround
" 
"
"                    --- Tool usage ---
" 
" Session Man      ⇒ Session manager
"   https://github.com/vim-scripts/sessionman.vim
" 
" Notes            ⇒ Notes manager
"   https://github.com/xolox/vim-notes
"
" MRU              ⇒ Most recently used files
"   https://github.com/yegappan/mru
"               
"
" # Dependencies
"  https://github.com/xolox/vim-misc
"
"                 ### PLUGIN SETTINGS ###

"                    --- Visual ---
"" LightLine
set laststatus=2
let g:lightline = { 'colorscheme': 'wombat' }

"                  --- Filesystem ---
"" netrw
let g:netrw_liststyle=3 " tree-view
let g:netrw_banner=0    " hide banner
"" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v([\/]\.(git|hg|svn)|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|suo|opensdf|sdf|vspscc|filters)$',
  \ }
let g:ctrlp_root_markers = [ '\v\.sln' ]
"" NERDtree
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <leader>r :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__']

"                   --- Editing ---
"" Bclose
let b:bclose_multiple=0
nnoremap <leader>b :Bclose<CR>
vnoremap <leader>b :Bclose<CR>
"" Vim-Unimpaired
" Single line
nnoremap <C-Up> [e
nnoremap <C-Down> ]e
" Multi-lines
vnoremap <C-Up> [egv
vnoremap <C-Down> ]egv
"" Vim-Easy-Align
"Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)

"                    --- Tool usage ---
"" Session Man
let g:sessionman_save_on_exit=0
"" Notes
let g:notes_directories=[ "~/.vim/notes" ]
let g:notes_suffix=".txt"
let g:notes_title_sync="yes"


"""""""
" CppDev (Own plugin)
nnoremap <silent> <leader>tt :ToggleHS<CR>
vnoremap <silent> <leader>tt :ToggleHS<CR>
