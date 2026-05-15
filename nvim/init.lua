local function setLeader()
  vim.g.mapleader = " "
end

local function disableMouse()
  vim.opt.mouse = ""
end

local function setIndentation()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
end

local function tweakDisplay()
  vim.opt.wrap = false
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.o.termguicolors = true
  vim.o.cursorline = true
end

local function tweakNetrw()
  vim.g.netrw_banner = 0 -- Hide banner
  vim.g.netrw_liststyle = 3 -- Tree view
  vim.g.netrw_preview = 0 -- Preview below
end

local function setBackups()
  vim.opt.swapfile = true
  vim.opt.directory = os.getenv("HOME") .. "/.nvim/swapfiles"
  vim.opt.backup = true
  vim.opt.backupdir = os.getenv("HOME") .. "/.nvim/backupfiles"
  vim.opt.undofile = true
  vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undofiles"
end

local function setPlugins()
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

local function enableCodeFolding()
  -- Use treesitter by default
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  -- Start buffers with nothing folded
  vim.opt.foldlevelstart = 99
end

local function setupFiletypeDetection()
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
            end
          end
        end,
      },
    },
  })
end

setBackups()
setIndentation()
setLeader()
setPlugins()
tweakDisplay()
tweakNetrw()
disableMouse()
enableCodeFolding()
setupFiletypeDetection()
