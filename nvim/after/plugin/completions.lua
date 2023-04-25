local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<c-o>'] = cmp.mapping.complete(),
    ['<c-e>'] = cmp.mapping.abort(),
    ['<cr>'] = cmp.mapping.confirm({ select = true })
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }
    }, {
      { name = 'buffer' }
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  }
})
