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

call plug#begin()

Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-sleuth'

call plug#end()

" Enable 24-bit color
set termguicolors

" Set the colorscheme
set background=dark
colorscheme solarized8

