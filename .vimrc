" Vundle plugins
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bufexplorer.zip'
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'derekwyatt/vim-scala'
Plugin 'fatih/vim-go'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'

call vundle#end()
filetype plugin indent on

"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

" YCM
" TODO

" Solarized

let g:solarized_termtrans=1
set background=light
colorscheme solarized

" BufExplorer
let g:bufExplorerFindActive=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy='fullpath'
let g:bufExplorerSplitOutPathName=0

" CtrlP
"let g:ctrlp_working_path_mode = ''

" vim-go
let g:go_bin_path = expand("~/.vim-go")

" vim-session
let g:session_autoload = 'no'
let g:session_autosave='yes'
let g:session_autosave_periodic=5

" YCM
let g:ycm_complete_in_comments = 1

" Whitespace
set list listchars=tab:\ \ ,trail:\ 
highlight SpecialKey ctermbg=Yellow guibg=Yellow

" General
syntax on

let g:enable_local_swap_dirs = 1
let mapleader = ","

set cindent
set cmdheight=4
set colorcolumn=+1
set expandtab
set foldlevel=1
set foldmethod=syntax
set hlsearch
set incsearch
set laststatus=2
set number
"set pastetoggle=<C-P>
set shiftwidth=2
set shortmess=a
set showmatch
set showmode
set softtabstop=2
set tabstop=2
set textwidth=80
set undofile
set wildmode=longest,list

" Shortcuts

" make regexes very magic
nnoremap / /\v
vnoremap / /\v

nnoremap <leader>bn :bNext<CR>
nnoremap <leader>bp :bPrevious<CR>
nnoremap <leader>bs :BufExplorerHorizontalSplit<CR>
nnoremap <leader>bv :BufExplorerVerticalSplit<CR>
nnoremap <leader>bx :BufExplorer<CR>

nnoremap <leader>e :CtrlP<CR>

nnoremap <leader>f :e! % <CR>

nnoremap <leader>gc :Gcommit <CR>
nnoremap <leader>gd :Gdiff <CR>
nnoremap <leader>ge :Gedit <CR>
nnoremap <leader>gf :Gread <CR>
nnoremap <leader>gg :Git 
nnoremap <leader>gm :Gmove 
nnoremap <leader>gr :Gremove <CR>
nnoremap <leader>gs :Gstatus <CR>
nnoremap <leader>gw :Gwrite <CR>

" Remove trailing whitespace
nnoremap <leader>rs :%s/\s\+$//e<CR>

" Reselect text that was just pasted
nnoremap <leader>v V`]

" Move around, and split, windows
nnoremap <leader>wh <C-w>h
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l
nnoremap <leader>wq <C-w>q
nnoremap <leader>ws <C-w>s<C-w>j
nnoremap <leader>wv <C-w>v<C-w>l
nnoremap <leader>ww <C-w>=

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
