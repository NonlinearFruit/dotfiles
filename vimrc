" Pluggins
" https://vimawesome.com
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

call plug#end()

" Indentation = 2 spaces
set ts=2
set sts=2
set sw=2
set et

" Remove newbie crutches
nnoremap <Left> <Nop>
vnoremap <Left> <Nop>
inoremap <Left> <Nop>

nnoremap <Right> <Nop>
vnoremap <Right> <Nop>
inoremap <Right> <Nop>

nnoremap <Up> <Nop>
vnoremap <Up> <Nop>
inoremap <Up> <Nop>

nnoremap <Down> <Nop>
vnoremap <Down> <Nop>
inoremap <Down> <Nop>

inoremap <BS> <Nop>
inoremap <Del> <Nop>
