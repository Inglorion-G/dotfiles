" install vim-plug if not already installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source ~/.config/nvim/init.vim
endif

" =================================================================================================
" ----- Plugins -----
" =================================================================================================
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'              " file explorer
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim'                 " fuzzy finder
Plug 'Shougo/deoplete.nvim'             " autocompletion
Plug 'mileszs/ack.vim'                  " regex search
Plug 'tpope/vim-commentary'             " comments
Plug 'tpope/vim-fugitive'               " git wrapper
Plug 'tpope/vim-surround'               " parens, brackets, etc
Plug 'christoomey/vim-tmux-navigator'   " easy navigation
Plug 'sheerun/vim-polyglot'             " language syntax support
Plug 'skalnik/vim-vroom'                " run tests
Plug 'w0rp/ale'                         " linter
Plug 'mhartington/oceanic-next'         " color scheme
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'             " auto closing delimiters

call plug#end()

" add jbuilder syntax highlighting
au BufNewFile,BufRead *.jbuilder set ft=ruby

" =================================================================================================
" ----- Settings -----
" =================================================================================================

" core config
set hlsearch                            " highlight search terms
set clipboard=unnamed                   " clipboard support
set history=500		                      " keep 50 lines of command line history
set ruler		                            " show the cursor position all the time
set mouse=a                             " mouse support
set backspace=indent,eol,start          " backspace behavior
set showcmd	    	                      " display incomplete commands
set incsearch	  	                      " highlight while searching
set number                              " show line numbers
set rnu                                 " show relative line numbers
set smartcase                           " better searching
set re=1                                " use regex engine 1
set ignorecase                          " case insensitive matching
set tabstop=2
set shiftwidth=2
set expandtab

" backup / swap
set backupskip=/tmp*,/private/tmp/*
set directory=$HOME/.config/nvim/swap/
set backupdir=$HOME/.config/nvim/backup/

" color scheme
syntax enable
set background=dark
colorscheme OceanicNext

if (has("&termguicolors"))
  set termguicolors
endif

" nerd tree
let NERDTreeShowHidden=1

" Airline
let g:airline_powerline_fonts=0
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='oceanicnext'

" fzf
let g:fzf_buffers_jump = 1

" deoplete
let g:deoplete#enable_at_startup = 1

" =================================================================================================
" ----- Mappings -----
" =================================================================================================
let mapleader = "\<Space>"

" nerd tree
nmap <leader>ne :NERDTreeToggle<cr>
nmap <leader>nf :NERDTreeFind<cr>

" utility
nmap <leader>tw :call TrimWhiteSpace()<cr>
nmap <leader>sv :source ~/.config/nvim/init.vim<cr>
nmap <leader>hl :nohls<cr>
nmap <leader>alet :ALEToggle<cr>

" 'zoom' a window - opens new tab with current buffer
nnoremap <leader>z :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>zz :wincmd =<cr>

" copy to system clipboard
nmap <leader>cp :%w !pbcopy<cr>

" yank current path to clipboard
noremap <silent><leader>yp :let @+=expand("%")<CR>
noremap <silent><leader>yfp :let @+=expand("%:p")<CR>

" easier working with tabs
nmap <leader>tt :tabnew<cr>
nmap <leader>tn :tabn<cr>
nmap <leader>tl :tabp<cr>

" fuzzy finding
nmap <C-p> :Files<cr>
nmap <C-o> :Buffers<cr>

" use 'jj' to exit insert mode
inoremap jj <Esc>:w<CR>

" disable Ex mode
noremap Q <nop>

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup	 " keep a backup file
endif

if executable('rg')
  " Use RipGrep over Grep and Ack
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  let g:ackprg = 'rg --vimgrep --no-heading'
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  filetype plugin indent on " file type detection, auto language-dependent indenting

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " filetype styles
  autocmd Filetype html setlocal ts=2 sw=2 expandtab
  autocmd Filetype erb setlocal ts=2 sw=2 expandtab
  autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
  autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
  autocmd Filetype json setlocal ts=2 sw=2 expandtab
  " autocmd Filetype javascript setlocal ts=2 sw=2 expandtab

  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" ----- Functions -----
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction

function! ConvertToUnix()
  :e ++ff=dos<cr>
  :set ff=unix<cr>
  :w
endfunction

" ----- Utility -----
"
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
