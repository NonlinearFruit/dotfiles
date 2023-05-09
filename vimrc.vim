" Indentation = 2 spaces
set ts=2
set sts=2
set sw=2
set et

let mapleader = ' '

""" RIDER """

" Mimic Vanilla Vim
nnoremap g, :action JumpToLastChange<cr>
nnoremap g; :action JumpToNextChange<cr>
vnoremap = :action ReformatCode<cr>

" Mimic Custom Vim
noremap ]h :action VcsShowNextChangeMarker<cr>
noremap [h :action VcsShowPrevChangeMarker<cr>

nnoremap ]d :action ReSharperGotoNextErrorInSolution<cr>
nnoremap [d :action ReSharperGotoPreviousErrorInSolution<cr>

noremap <leader>// :action Find<cr>
nnoremap <leader>bc :action BuildSolutionAction<cr>
nnoremap <leader>at :action RiderUnitTestRunSolutionAction<cr>

" Rider Rewrites
nnoremap gi :action GotoImplementation<cr>

" Rider Plugins
nnoremap gl :action uk.co.ben_gibson.git.link.ui.actions.menu.CopyAction<cr>

" Notes
" - Reload rc :: :source ~/.ideavimrc
