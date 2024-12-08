local function install_lsp_if_needed()
  local pkg = "clojure-lsp"
  if not require("mason-registry").is_installed(pkg) then
    require("mason.api.command").MasonInstall({ pkg })
  end
end

local function configure_lsp()
  local lsp_ok, lsp_config = pcall(require, "lspconfig")
  if not lsp_ok then
    return
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local function on_attach(client, bufnr)
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, { buffer = bufnr, remap = false, desc = "[g]oto [d]efinition" })
    vim.keymap.set("n", "<leader>gd", function()
      vim.lsp.buf.definition()
    end, { buffer = bufnr, remap = false, desc = "[g]oto [d]efinition" })
    vim.keymap.set("n", "<leader>gr", function()
      vim.lsp.buf.references()
    end, { buffer = bufnr, remap = false, desc = "[g]oto [r]eferences" })
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, { buffer = bufnr, remap = false, desc = "[K]now what this is" })
    vim.keymap.set({ "n", "i", "v" }, "<c-k>", function()
      vim.diagnostic.open_float()
    end, { buffer = bufnr, remap = false, desc = "[k]now what is wrong" })
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.goto_next()
    end, { buffer = bufnr, remap = false, desc = "[]] Next [d]iagnostic" })
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.goto_prev()
    end, { buffer = bufnr, remap = false, desc = "[[] Previous [d]iagnostic" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, { buffer = bufnr, remap = false, desc = "[c]ode [a]ctions" })
    vim.keymap.set({ "n", "v" }, "<leader>rr", function()
      vim.lsp.buf.rename()
    end, { buffer = bufnr, remap = false, desc = "[r]efactor [r]ename" })

    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, { buffer = bufnr, remap = false })
    vim.keymap.set("n", "<leader>vws", function()
      vim.lsp.buf.workspace_symbol()
    end, { buffer = bufnr, remap = false })
    vim.keymap.set("n", "=", function()
      vim.lsp.buf.format()
    end, { buffer = bufnr, remap = false, desc = "[=] Format file" })
  end

  lsp_config.clojure_lsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
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
  dev = true,
}
