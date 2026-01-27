" Basic settings
set number                " Line numbers
"set relativenumber        " Relative line numbers
set mouse=a              " Enable mouse
set ignorecase           " Case insensitive search
set smartcase            " Unless uppercase is used
set incsearch            " Incremental search
set hlsearch             " Highlight search results
set expandtab            " Use spaces instead of tabs
set tabstop=4            " Tab width
set shiftwidth=4         " Indent width
set autoindent           " Auto indent
set clipboard=unnamedplus " Use system clipboard
syntax on                " Syntax highlighting
filetype plugin indent on

" Quality of life
set undofile             " Persistent undo
set updatetime=300       " Faster updates
set timeoutlen=500       " Faster key sequences

" Plugins are managed by Nix in home.nix

" Enable 24-bit color
set termguicolors

" Set the colorscheme
set background=dark
colorscheme NeoSolarized

" fix Y to yank the whole line including newline
nnoremap Y yy
