local function configure()
  local runner = require("runner")
  vim.keymap.set("n", "<leader>vd", runner.close, { desc = "[v]imux [d]elete" })
  vim.keymap.set("n", "<leader>vp", runner.prompt, { desc = "[v]imux [p]rompt" })
  vim.keymap.set("n", "<leader>vr", function()
    runner.run("!!")
  end, { desc = "[v]imux [r]erun the last command" })
  vim.keymap.set(
    "n",
    "<leader>vz",
    runner.zoom,
    { desc = "[v]imux [z]oom (tmux <leader>-z to toggle https://superuser.com/a/576505/468052)" }
  )
end

return {
  "local/runner",
  cond = function()
    return vim.fn.executable("tmux") == 1
  end,
  config = configure,
  dev = true,
}
