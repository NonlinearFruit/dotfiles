" Pluggins
" https://vimawesome.com
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'benmills/vimux'

call plug#end()

" Indentation = 2 spaces
set ts=2
set sts=2
set sw=2
set et

" Remove newbie crutches in Command Mode
cnoremap <BS> <Nop>
cnoremap <Del> <Nop>
cnoremap <Down> <Nop>
cnoremap <Left> <Nop>
cnoremap <Right> <Nop>
cnoremap <Up> <Nop>

" Remove newbie crutches in Insert Mode
inoremap <BS> <Nop>
inoremap <Del> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>

" Remove newbie crutches in Normal Mode
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>

" Remove newbie crutches in Visual Mode
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>

" Standardize swap location
:set directory=$HOME/.vim/swapfiles//
