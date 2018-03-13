" Use Vim settings, rather than Vi settings (much better!)
set nocompatible

" directories for backup files
set dir=~/.vim_temp
set backupdir=~/.vim_temp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" install vim-plug if not already installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source ~/.config/nvim/init.vim
endif

" ----- Plugins -----
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'              " file explorer
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim'                 " fuzzy finder
Plug 'Valloric/YouCompleteMe'           " autocompletion
Plug 'mileszs/ack.vim'                  " regex search
Plug 'tpope/vim-commentary'             " comments
Plug 'tpope/vim-fugitive'               " git wrapper
Plug 'tpope/vim-surround'               " parens, brackets, etc
Plug 'christoomey/vim-tmux-navigator'   " easy navigation
Plug 'sheerun/vim-polyglot'
Plug 'skalnik/vim-vroom'                " run tests
Plug 'w0rp/ale'                         " linter
Plug 'mhartington/oceanic-next'         " color scheme
Plug 'vim-airline/vim-airline'


call plug#end()

" ----- Color Scheme and Syntax -----
syntax enable
colorscheme OceanicNext
set hlsearch
if (has("termguicolors"))
  set termguicolors
endif

" add jbuilder syntax highlighting
au BufNewFile,BufRead *.jbuilder set ft=ruby

" ----- Options -----
set history=50		" keep 50 lines of command line history
set ruler		      " show the cursor position all the time
set showcmd	    	" display incomplete commands
set incsearch	  	" do incremental searching
set number        " show line numbers
set rnu           " show relative line numbers
set smartcase     " better searching
set re=1          " use regex engine 1
set tabstop=2
set shiftwidth=2
set expandtab

" ----- Mappings -----
let mapleader = "\<Space>"

" nerd tree
nmap <leader>ne :NERDTreeToggle<cr>
nmap <leader>nf :NERDTreeFind<cr>

" utility
nmap <leader>tw :call TrimWhiteSpace()<cr>
nmap <leader>sv :source $MYVIMRC<cr>
nmap <leader>hl :nohls<cr>

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

" Airline
let g:airline_powerline_fonts=0
let g:airline#extensions#ale#enabled = 1

if has('mouse')
  set mouse=a
endif

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup	 " keep a backup file
endif

if executable('rg')
  " Use Ag over Grep and Ack
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

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" inoremap <C-U> <C-G>u<C-U>

" ----- Utility -----
"
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
