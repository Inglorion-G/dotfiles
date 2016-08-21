" Use Vim settings, rather than Vi settings (much better!)
set nocompatible

" directories for backup files
set dir=~/.vim_temp
set backupdir=~/.vim_temp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" ----- Plugins -----
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'        " file explorer
Plug 'ctrlpvim/ctrlp.vim'         " fuzzy finder
Plug 'Valloric/YouCompleteMe'     " autocompletion

call plug#end()

" ----- Options -----
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set number              " show line numbers
set rnu                 " show relative line numbers

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  colorscheme SpacegrayEighties
  set hlsearch
endif

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " filetype styles
  autocmd Filetype html setlocal ts=2 sw=2 expandtab
  autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
  autocmd Filetype javascript setlocal ts=4 sw=4 expandtab

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

" ----- Macros -----
let mapleader = "\<Space>"

nmap <leader>ne :NERDTreeToggle<cr>

" mappings -----

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" ----- Utility -----
"
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

