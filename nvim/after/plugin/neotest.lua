local neotest_ok, neotest = pcall(require, 'neotest')
if not neotest_ok then
  return
end

local function keymap(key, cmd, description)
  vim.keymap.set({"n", "v"}, key, "<cmd>"..cmd.."<cr>", { desc = description })
end

keymap("<leader>tcr", "lua require('neotest').run.run(vim.fn.expand('%'))", "[t]est [c]lass [r]un")
keymap("<leader>tcd", "lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})", "[t]est [c]lass [d]ebug")
keymap("<leader>tr", "lua require('neotest').run.run()", "[t]est [r]un")
keymap("<leader>td", "lua require('neotest').run.run({strategy = 'dap'})", "[t]est [d]ebug")
keymap("<leader>tsr", "lua require('neotest').run.run({suite = true})", "[t]est [s]uite [r]un")
keymap("<leader>tsd", "lua require('neotest').run.run({suite = true, strategy = 'dap'})", "[t]est [s]uite [d]ebug")
keymap("<leader>tw", "lua require('neotest').summary.toggle()", "[t]est [w]indow")

local adapters = {}
if packer_plugins["neotest-dotnet"] and packer_plugins["neotest-dotnet"].loaded then
  table.insert(adapters, require("neotest-dotnet"))
end
neotest.setup({
  adapters = adapters,
  diagnostic = {
    enabled = true
  }
})
