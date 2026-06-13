local function set_leader()
  vim.g.mapleader = " "
end

local function disable_mouse()
  vim.opt.mouse = ""
end

local function set_indentation()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
end

local function tweak_display()
  vim.opt.wrap = false
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.o.termguicolors = true
  vim.o.cursorline = true
end

local function tweak_netrw()
  vim.g.netrw_banner = 0 -- Hide banner
  vim.g.netrw_liststyle = 3 -- Tree view
  vim.g.netrw_preview = 0 -- Preview below
end

local function set_backups()
  vim.opt.backup = true
  vim.opt.undofile = true
  vim.opt.backupdir = os.getenv("HOME") .. "/.nvim/backupfiles"
end

local function set_plugins()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup("plugins", {
    change_detection = {
      notify = false,
    },
  })
end

local function enable_code_folding()
  -- Use treesitter by default
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  -- Start buffers with nothing folded
  vim.opt.foldlevelstart = 99
end

local function setup_filetype_detection()
  vim.filetype.add({
    pattern = {
      [".*"] = {
        priority = -1,
        function(path, _)
          local stat = vim.uv.fs_stat(path)
          if stat and stat.type == "file" then
            local content = vim.fn.readfile(path, "", 1)[1] or ""
            if content:match("deno") then
              return "javascript"
            elseif content:match("bb") then
              return "clojure"
            end
          end
        end,
      },
    },
  })
end

set_backups()
set_indentation()
set_leader()
set_plugins()
tweak_display()
tweak_netrw()
disable_mouse()
enable_code_folding()
setup_filetype_detection()
