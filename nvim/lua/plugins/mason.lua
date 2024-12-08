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

  vim.keymap.set("n", "<leader>lsp", "<cmd>Mason<cr>", { desc = "[LSP] Manage language server installs" })

  -- Resources:
  -- https://github.com/mfussenegger/nvim-dap
  -- https://github.com/rcarriga/nvim-dap-ui
  -- https://aaronbos.dev/posts/debugging-csharp-neovim-nvim-dap

  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end
  local dapui_ok, dapui = pcall(require, "dapui")
  if not dapui_ok then
    return
  end

  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    -- Use this to override mappings for specific elements
    element_mappings = {
      -- Example:
      -- stacks = {
      --   open = "<CR>",
      --   expand = "o",
      -- }
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    -- Layouts define sections of the screen to place windows.
    -- The position can be "left", "right", "top" or "bottom".
    -- The size specifies the height/width depending on position. It can be an Int
    -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- Elements are the elements shown in the layout (in order).
    -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = "scopes", size = 0.25 },
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40, -- 40 columns
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
    controls = {
      -- Requires Neovim nightly (or 0.8 when released)
      enabled = true,
      -- Display controls in this element
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "↻",
        terminate = "",
      },
    },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
      border = "single", -- Border style. Can be "single", "double" or "rounded"
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil, -- Can be integer or nil.
      max_value_lines = 100, -- Can be integer or nil.
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  vim.fn.sign_define("DapBreakpoint", { text = "🛑" })
  vim.fn.sign_define("DapStopped", { text = "💥" })

  local function keymap(key, cmd, description)
    vim.keymap.set({ "n", "i", "v" }, key, "<cmd>" .. cmd .. "<cr>", { desc = description })
  end

  keymap("<f3>", "lua require('dap').run_last()", "Run last")
  keymap("<f4>", "lua require('dap').repl.open()", "Open REPL")
  keymap("<f5>", "lua require('dap').continue()", "Start debugger/Continue")
  keymap("<f9>", "lua require('dap').toggle_breakpoint()", "Toggle breakpoint")
  keymap("<f10>", "lua require('dap').step_over()", "Step over")
  keymap("<f11>", "lua require('dap').step_into()", "Step into")
  keymap("<f12>", "lua require('dap').step_out()", "Step out")
end

return {
  "williamboman/mason.nvim", -- Tool to install LSP/DAP/linter/formatters
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- easier to configure mason
    "neovim/nvim-lspconfig", -- configure lsps
  },
  config = configure,
}
