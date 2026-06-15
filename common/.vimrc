let mapleader = " "
let maplocalleader = ","

set nocompatible
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set timeout
set timeoutlen=100
set incsearch

syntax on
filetype plugin indent on

" Use CTRL-L to clear the highlighting of 'hlsearch' (off by default) and call
" :diffupdate.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

set laststatus=2
set ruler
set wildmenu

set scrolloff=1
set sidescroll=1
set sidescrolloff=2

set display+=lastline
set display+=truncate

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set formatoptions+=j

setglobal tags-=./tags tags-=./tags; tags^=./tags;

set autoread

set history=1000

set tabpagemax=50

set viminfo^=!

set sessionoptions-=options
set viewoptions-=options

set hlsearch

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set iskeyword=@,48-57,_,192-255,-

" Keymaps
" Move selection up/down
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
" Join keeping cursor position
nnoremap J mzJ`z
" Center on next/prev search match
nnoremap n nzzzv
nnoremap N Nzzzv
" Center on half-page scroll
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Delete into black-hole register
nnoremap <leader>d "_d
xnoremap <leader>d "_d
" Replace word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
" Keep selection when indenting
xnoremap < <gv
xnoremap > >gv
" Open netrw in the current file's directory
nnoremap - :Explore<CR>
" Close current buffer
nnoremap <leader>bd :bdelete<CR>
" Cycle buffers
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
" Yank file path to the clipboard: absolute / relative to cwd
nnoremap <leader>yp :let @+=expand('%:p')<CR>
nnoremap <leader>yr :let @+=expand('%:.')<CR>

" Autocmds
" Soft-wrap prose files
augroup vimrc_prose
  autocmd!
  autocmd FileType text,plaintex,gitcommit,markdown setlocal wrap
augroup END
