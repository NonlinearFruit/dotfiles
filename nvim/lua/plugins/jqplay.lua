local function configure()
  vim.keymap.set("n", "<leader>jq", function()
    require("jqplay").Start(nil, nil, vim.fn.bufnr())
  end, { desc = "Interactive [j][q]" })
end

return {
  "local/jqplay",
  cond = function()
    return vim.fn.executable("jq") == 1
  end,
  ft = "json",
  config = configure,
  dev = true,
}
