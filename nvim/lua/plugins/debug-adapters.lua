local function key_mappings()
  local function keymap(key, cmd, description)
    vim.keymap.set({ "n", "i", "v" }, key, "<cmd>" .. cmd .. "<cr>", { desc = description })
  end

  keymap("<f3>", "lua require('dap').run_last()", "Run last")
  keymap("<f4>", "DapViewJump repl", "Open REPL")
  keymap("<f5>", "lua require('dap').continue()", "Start debugger/Continue")
  keymap("<f9>", "lua require('dap').toggle_breakpoint()", "Toggle breakpoint")
  keymap("<f10>", "lua require('dap').step_over()", "Step over")
  keymap("<f11>", "lua require('dap').step_into()", "Step into")
  keymap("<f12>", "lua require('dap').step_out()", "Step out")
  -- :DapViewClose to close all dap-view windows
  -- :DapViewToggle
end

local function configure_dap_view()
  local dv_ok, dv = pcall(require, "dap-view")
  if not dv_ok then
    return
  end

  -- https://igorlfs.github.io/nvim-dap-view/configuration#Defaults
  dv.setup({
    auto_toggle = true,
  })

  vim.fn.sign_define("DapBreakpoint", { text = "🛑" })
  vim.fn.sign_define("DapStopped", { text = "💥" })
end

local function configure()
  -- Resources:
  -- https://github.com/mfussenegger/nvim-dap
  -- https://github.com/igorlfs/nvim-dap-view
  key_mappings()
  configure_dap_view()
end

return {
  "igorlfs/nvim-dap-view",
  config = configure,
  event = "VeryLazy",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
}
