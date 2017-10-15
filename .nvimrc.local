set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'FelikZ/ctrlp-py-matcher'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'SirVer/ultisnips'
Plug 'altercation/vim-colors-solarized'
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'jlanzarotta/bufexplorer'
Plug 'natebosch/dartlang-snippets'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
" Plug 'derekwyatt/vim-scala'
" Plug 'fatih/vim-go'
" Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-speeddating'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-vinegar'
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-session'

call plug#end()

" Solarized

set background=light
let g:solarized_termtrans=1
colorscheme solarized

highlight! StatusLine ctermfg=7
highlight! StatusLineNC ctermfg=7
highlight! VertSplit ctermfg=7 ctermbg=7

" BufExplorer
let g:bufExplorerFindActive=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy='fullpath'
let g:bufExplorerSplitOutPathName=0

" CtrlP
"let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ --ignore .git5_specs
      \ --ignore review
      \ -g ""'
let g:ctrlp_working_path_mode=''

" deoplete
let g:deoplete#enable_at_startup = 1
autocmd FileType html let b:deoplete_disable_auto_complete = 1

" LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'dart': ['dart_language_server'],
    \ }
    " \ 'html': 'dart_language_server',
let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsDisplay = {
      \      1: {
      \          "name": "Error",
      \          "texthl": "ALEError",
      \          "signText": "X",
      \          "signTexthl": "ALEErrorSign",
      \      },
      \      2: {
      \          "name": "Warning",
      \          "texthl": "ALEWarning",
      \          "signText": "!",
      \          "signTexthl": "ALEWarningSign",
      \      },
      \      3: {
      \          "name": "Information",
      \          "texthl": "ALEInfo",
      \          "signText": "i",
      \          "signTexthl": "ALEInfoSign",
      \      },
      \      4: {
      \          "name": "Hint",
      \          "texthl": "ALEInfo",
      \          "signText": ">",
      \          "signTexthl": "ALEInfoSign",
      \      },
      \ }
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" vim-go
let g:go_bin_path=expand("~/.vim-go")

" vim-session
let g:session_autoload='no'
let g:session_autosave='yes'
let g:session_autosave_periodic=5

" whitespace
autocmd BufWritePre * StripWhitespace

" Highlight errors and warnings with red/magenta undercurl
hi SpellBad term=none ctermbg=none cterm=undercurl ctermfg=Red gui=undercurl guisp=Red
hi SpellCap term=none ctermbg=none cterm=undercurl ctermfg=Magenta gui=undercurl guisp=Magenta

" General
let g:enable_local_swap_dirs=1
let mapleader=","

set cindent
set cmdheight=4
set colorcolumn=+1
set expandtab
set foldlevel=1
set foldmethod=syntax
set hlsearch
set incsearch
set laststatus=2
set mouse=c
set number
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

nnoremap <leader>d :YcmCompleter GoToDefinition<CR>

nnoremap <leader>e :CtrlPMixed<CR>

nnoremap <leader>f :e! % <CR>

nnoremap <leader>gd :edit %:p:s?\.[^.]*$?.dart?<CR>
nnoremap <leader>gh :edit %:p:s?\.[^.]*$?.html?<CR>
nnoremap <leader>gs :edit %:p:s?\.[^.]*$?.scss?<CR>

nnoremap <leader>p :set invpaste paste?<CR>

nnoremap <leader>s :source ~/.config/nvim/init.vim <CR>

" Tabs
nnoremap <leader>tc :tabnew <CR>
nnoremap <leader>tn :tabnext <CR>
nnoremap <leader>tp :tabprevious <CR>
nnoremap <leader>tq :tabclose <CR>

" Trim trailing whitespace
nnoremap <leader>tw :%s/\s\+$//e<CR>

" Reselect text that was just pasted
nnoremap <leader>v V`]

" Move around, and split, windows
nnoremap <leader>wh <C-w>h
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l
nnoremap <leader>wq <C-w>q
nnoremap <leader>wr <C-w>=
nnoremap <leader>ws <C-w>s<C-w>j
nnoremap <leader>wv <C-w>v<C-w>l

nnoremap <leader>wn :noautocmd w <CR>
nnoremap <leader>ww :w <CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

filetype plugin indent on
syntax on
