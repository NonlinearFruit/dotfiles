" Pluggins
" https://vimawesome.com
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align' " Aligning markdown tables
Plug 'benmills/vimux'          " For tomoto-do and tmux
Plug 'sheerun/vim-polyglot'    " For more language syntaxs

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
nnoremap hh <Nop>
nnoremap jj <Nop>
nnoremap kk <Nop>
nnoremap ll <Nop>

" Remove newbie crutches in Visual Mode
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>
vnoremap hh <Nop>
vnoremap jj <Nop>
vnoremap kk <Nop>
vnoremap ll <Nop>

" Standardize swap location
:set directory=$HOME/.vim/swapfiles//

" Persistant undo (even after closing file)
set undofile
set undodir=~/.vim/undofiles//

" Vimux
let g:VimuxResetSequence = ""
map vd :call VimuxCloseRunner()<CR>
map vp :call VimuxPromptCommand()<CR>
map vz :call VimuxZoomRunner()<CR>
if has("autocmd")
  filetype on
  autocmd FileType go map vr :call VimuxRunCommand("go run")<CR>
  autocmd FileType go map vc :call VimuxRunCommand("go build")<CR>
  autocmd FileType go map vu :call VimuxRunCommand("go test -v ./...")<CR>
endif
