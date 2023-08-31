local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  return
end

require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets/" })

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<c-space>"] = cmp.mapping.complete(),
    ["<esc>"] = cmp.mapping.abort(),
    ["<tab>"] = cmp.mapping.confirm({ select = true }),
    ["<cr>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
})
