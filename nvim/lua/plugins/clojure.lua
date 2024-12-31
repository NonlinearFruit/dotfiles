local function install_lsp_if_needed()
  local pkg = "clojure-lsp"
  if not require("mason-registry").is_installed(pkg) then
    require("mason.api.command").MasonInstall({ pkg })
  end
end

local function configure_lsp()
  local lsp = require("language-server")
  local lsp_config_ok, lsp_config = pcall(require, "lspconfig")
  if not lsp_config_ok then
    return
  end

  lsp_config.clojure_lsp.setup({
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
  })
end

local function runner_keybindings()
  local function runner_keymap(key, shellCommand, description)
    vim.keymap.set(
      "n",
      "<leader>" .. key,
      "<cmd>wa | lua require('runner').run('" .. shellCommand .. "')<cr>",
      { desc = description }
    )
  end

  runner_keymap("at", "lein spec", "[A]ll [T]ests")
  runner_keymap("bc", "lein compile", "[B]uild/[C]ompile")
  runner_keymap("er", "lein run", "[E]xecute [R]un")
end

local function configure()
  runner_keybindings()
  install_lsp_if_needed()
  -- :LspStart on first load
  configure_lsp()
end

return {
  "local/clojure",
  config = configure,
  ft = "clojure",
  virtual = true,
}
