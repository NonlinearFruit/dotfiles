local function install_lsp_if_needed()
  require("installer").install_if_missing({
    "clojure-lsp", -- LSP
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
  vim.lsp.enable("clojure_lsp")
end

return {
  "local/clojure",
  config = configure,
  ft = "clojure",
  virtual = true,
}
