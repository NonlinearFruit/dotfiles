local function configure()
  local runner = require("runner")
  local helpers = require("helpers")
  vim.keymap.set("n", "<leader>vd", runner.close, { desc = "[v]imux [d]elete" })
  vim.keymap.set("n", "<leader>vp", runner.prompt, { desc = "[v]imux [p]rompt" })

  vim.keymap.set("n", "<leader>vr", function()
    runner.run("!!")
  end, { desc = "[v]imux [r]epeat the last command" })

  vim.keymap.set(
    "n",
    "<leader>vz",
    runner.zoom,
    { desc = "[v]imux [z]oom (tmux <leader>-z to toggle https://superuser.com/a/576505/468052)" }
  )

  vim.keymap.set("v", "<leader>vp", function()
    runner.run(helpers.get_selected_text())
  end, { desc = "[v]imux [p]rompt with the selected code" })
end

return {
  "local/runner",
  cond = function()
    return vim.fn.executable("tmux") == 1
  end,
  config = configure,
  virtual = true,
}
