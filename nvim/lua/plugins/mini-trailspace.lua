local function configure()
  require("mini.trailspace").setup({})
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dashboard",
    callback = function()
      vim.b.minitrailspace_disable = true
    end,
  })
end

return {
  "echasnovski/mini.trailspace",
  config = configure,
}
