local function configure()
  local cmp_ok, cmp = pcall(require, "cmp")
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if not cmp_ok or not luasnip_ok then
    return
  end

  require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets/" })

  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<c-space>"] = cmp.mapping.complete(),
      ["<c-e>"] = cmp.mapping.abort(),
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
      ["<cr>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if luasnip.expandable() then
            luasnip.expand()
          else
            cmp.confirm({ select = true })
          end
        else
          fallback()
        end
      end),
      ["<tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<s-tab>"] = cmp.mapping(function(fallback)
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
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
end

return {
  "hrsh7th/nvim-cmp",
  opts = {},
  config = configure,
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- get completions from lsp
    "L3MON4D3/LuaSnip", -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- integrate luasnip and cmp(?)
  },
}
