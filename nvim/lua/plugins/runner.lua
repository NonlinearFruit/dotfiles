local function configure()
  local runner = require("runner")
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
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    local line_start = vstart[2]
    local line_end = vend[2]
    local lines = vim.fn.getline(line_start, line_end)
    runner.run(lines[1])
  end, { desc = "[v]imux [p]rompt with the selected code" })
end

return {
  "local/runner",
  cond = function()
    return vim.fn.executable("tmux") == 1
  end,
  config = configure,
  dev = true,
}
