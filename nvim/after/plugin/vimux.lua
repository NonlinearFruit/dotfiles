if not packer_plugins["vimux"] or not packer_plugins["vimux"].loaded then
  return
end

vim.g.VimuxResetSequence = ""
vim.g.VimuxOrientation = "h"
vim.g.VimuxHeight = "40"
vim.keymap.set("n", "<leader>vd", "<cmd>VimuxCloseRunner<cr>", { desc = "[v]imux [d]elete" })
vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<cr>", { desc = "[v]imux [p]rompt" })
vim.keymap.set("n", "<leader>vr", "<cmd>VimuxRunCommand('!!')<cr>", { desc = "[v]imux [v]erun the last command" })
vim.keymap.set(
  "n",
  "<leader>vz",
  "<cmd>VimuxZoomRunner<cr>",
  { desc = "[v]imux [z]oom (tmux <leader>-z to toggle https://superuser.com/a/576505/468052)" }
)
