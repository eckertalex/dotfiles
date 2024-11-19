" Disable compatibility mode
set nocompatible

" Leader Key
let mapleader = " "
let maplocalleader = " "

" Interface Settings
set number               " Show line numbers
set relativenumber       " Show relative line numbers
set mouse=a              " Enable mouse in all modes
set nowrap               " Disable line wrapping
set cursorline           " Highlight current line
set signcolumn=yes       " Always show sign column
set laststatus=2         " Always show status line
set wildmenu             " Enhanced command-line completion
set ruler                " Show cursor position
set scrolloff=10         " Context lines when scrolling
set sidescrolloff=8      " Context columns when side-scrolling
"set statusline=%=%m\ %f  " Simple status line format

" Editing Behavior
set backspace=indent,eol,start       " Backspace through everything
set smarttab                         " Smart tab behavior
set shiftwidth=4                     " Indent width
set tabstop=4                        " Tab display width
set list                             " Show invisible characters
set listchars=tab:»\ ,trail:·,nbsp:␣

" Search Settings
set ignorecase            " Case-insensitive search
set smartcase             " Case-sensitive if uppercase used
set incsearch             " Incremental search

" File Handling
filetype plugin indent on " Enable filetype detection
syntax on                 " Enable syntax highlighting
set autoread              " Reload files changed outside Vim
set undofile              " Persistent undo
set undodir=~/.vim/undodir

" Performance & History
set history=1000          " Command history size
set updatetime=200        " Update time for swap and CursorHold
set timeoutlen=300        " Timeout for key sequences

" Window Splitting
set splitbelow            " New windows below current
set splitright            " New windows right of current

" Completion & Command
set pumheight=10          " Max popup menu height
set virtualedit=block     " Free cursor in visual block mode
set winminwidth=5         " Minimum window width

" Additional Tweaks
set conceallevel=3        " Conceal markup in some modes
set formatoptions+=j      " Smart join of comment lines
set sessionoptions-=options
set viewoptions-=options
set clipboard=unnamed,unnamedplus

" Color Scheme
colorscheme habamax
