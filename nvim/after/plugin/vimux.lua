if not packer_plugins["vimux"] or not packer_plugins["vimux"].loaded then
  return
end

vim.g.VimuxResetSequence = ""
vim.g.VimuxOrientation = "h"
vim.g.VimuxHeight = "40"
vim.keymap.set("n", "<leader>vd", "<cmd>VimuxCloseRunner<cr>", { desc = "[V]imux [D]elete" })
vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<cr>", { desc = "[V]imux [P]rompt" })
vim.keymap.set(
  "n",
  "<leader>vz",
  "<cmd>VimuxZoomRunner<cr>",
  { desc = "[V]imux [Z]oom (tmux <leader>-z to toggle https://superuser.com/a/576505/468052)" }
)
