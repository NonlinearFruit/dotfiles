local function configure()
  local mason_ok, mason = pcall(require, "mason")
  if not mason_ok then
    return
  end

  local mason_lsp_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
  if not mason_lsp_ok then
    return
  end

  mason.setup({
    ui = {
      border = "rounded",
    },
  })

  mason_lsp_config.setup({
    automatic_installation = false,
  })

  --vim.lsp.set_log_level('debug')

  -- How diagnostics show up
  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = false,
  })

  local lsp = require("language-server")
  local capabilities = lsp.capabilities
  local on_attach = lsp.on_attach
  local lsp_config_ok, lsp_config = pcall(require, "lspconfig")
  if not lsp_config_ok then
    return
  end

  if os.execute("is termux") ~= 0 then
    lsp_config.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    })

    lsp_config.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.pylyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.bashls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.nushell.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.dockerls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.graphql.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.openscad_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.yamlls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
          },
        },
      },
    })
  end
end

return {
  "williamboman/mason.nvim", -- Tool to install LSP/DAP/linter/formatters
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- easier to configure mason
    "neovim/nvim-lspconfig", -- configure lsps
  },
  config = configure,
}
