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

" Comment
noremap gcc :action CommentByBlockComment<cr>
noremap gcb :action CommentByLineComment<cr>

" Hunks
noremap ]h :action VcsShowNextChangeMarker<cr>
noremap [h :action VcsShowPrevChangeMarker<cr>
nnoremap <leader>hr :action Vcs.RollbackChangedLines<cr>

" Diagnostics
noremap ]d :action ReSharperGotoNextErrorInSolution<cr>
noremap [d :action ReSharperGotoPreviousErrorInSolution<cr>

" Search
nnoremap <leader>// :action Find<cr>
nnoremap <leader>/g :action FindInPath<cr>

" Code Actions
" [c]ode [a]ctions
noremap <leader>ca :action ShowIntentionActions<cr>
" [r]efactor [a]ctions
noremap <leader>ra :action Refactorings.QuickListPopupAction<cr>
" [r]efactor [r]ename
noremap <Space>rr :action RenameElement<cr>
" [r]efactor [i]nline
noremap <Space>ri :action Inline<cr>
" noremap <Space>mv :action Move<CR>
" noremap <Space>ms :action MakeStatic<CR>
" noremap <Space>ci :action ConvertToInstanceMethod<CR>
" noremap <Space>em :action ExtractMethod<CR>
" noremap <Space>ei :action ExtractInterface<CR>
" noremap <Space>ef :action EncapsulateFields<CR>
" noremap <Space>rmo :action ReplaceMethodWithMethodObject<CR>
" noremap <Space>iv :action IntroduceVariable<CR>
" noremap <Space>ic :action IntroduceConstant<CR>
" noremap <Space>ip :action IntroduceParameter<CR>
" noremap <Space>if :action IntroduceField<CR>
" noremap <Space>po :action IntroduceParameterObject<CR>
" noremap <Space>pd :action MemberPushDown<CR>
" noremap <Space>pu :action MembersPullUp<CR>
" noremap <Space>RF :action RenameFile<CR>
" noremap <Space>cs :action ChangeSignature<CR>
" noremap <Space>ai :action AnonymousToInner<CR>

" Other
nnoremap <leader>bc :action BuildSolutionAction<cr>
nnoremap <leader>at :action RiderUnitTestRunSolutionAction<cr>
nnoremap <leader>vp :action ActivateTerminalToolWindow<cr>
nnoremap <leader>tr :action RiderUnitTestRunContextAction<cr>

" Rider Rewrites
nnoremap gi :action GotoImplementation<cr>

" Rider Plugins
nnoremap gl :action uk.co.ben_gibson.git.link.ui.actions.menu.CopyAction<cr>
set ideamarks

" Notes
" - Reload rc :: :source ~/.ideavimrc
