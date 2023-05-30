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
noremap gcc :action CommentByBlockComment<cr>
noremap gcb :action CommentByLineComment<cr>
noremap ]h :action VcsShowNextChangeMarker<cr>
noremap [h :action VcsShowPrevChangeMarker<cr>

noremap ]d :action ReSharperGotoNextErrorInSolution<cr>
noremap [d :action ReSharperGotoPreviousErrorInSolution<cr>

nnoremap <leader>// :action Find<cr>
nnoremap <leader>/g :action FindInPath<cr>
nnoremap <leader>bc :action BuildSolutionAction<cr>
nnoremap <leader>at :action RiderUnitTestRunSolutionAction<cr>
nnoremap <leader>vp :action ActivateTerminalToolWindow<cr>
nnoremap <leader>ca :action ShowIntentionActions<cr>
nnoremap <leader>hr :action Vcs.RollbackChangedLines<cr>

" Rider Rewrites
nnoremap gi :action GotoImplementation<cr>

" Rider Plugins
nnoremap gl :action uk.co.ben_gibson.git.link.ui.actions.menu.CopyAction<cr>

" Notes
" - Reload rc :: :source ~/.ideavimrc
