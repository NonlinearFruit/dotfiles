local function setLeader()
  vim.g.mapleader = " "
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
  vim.cmd.colorscheme("habamax")
  -- vim.api.nvim_command("hi LineNr guifg=grey ctermfg=grey")
  -- vim.api.nvim_command("hi Pmenu guibg=black ctermbg=black guifg=white ctermfg=white") -- Make popup windows not pink (https://vi.stackexchange.com/a/12665/11897)
  -- vim.cmd("highlight clear SignColumn")
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
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup("plugins")
end

local function setClipboard()
  vim.g.clipboard = {
    name = "Universal Clipboard",
    copy = {
      ["+"] = "clip copy",
      ["*"] = "clip copy",
    },
    paste = {
      ["+"] = "clip paste",
      ["*"] = "clip paste",
    },
    cache_enabled = 0,
  }
end

local function setBacholerLife()
  local function map(mode, key, cmd, description)
    vim.keymap.set(mode, key, cmd, { desc = description })
  end

  -- Remove obnoxious bindings
  map({ "n", "i" }, "<f1>", "<nop>", "This does nothing: Too close to Esc")

  -- Remove newbie crutches!
  map({ "n", "i", "v", "c" }, "<bs>", "<nop>", "This does nothing: Edit in normal mode")
  map({ "n", "i", "v", "c" }, "<del>", "<nop>", "This does nothing: Edit in normal mode")
  map({ "n", "i", "v", "c" }, "<down>", "<nop>", "This does nothing: Move in normal mode")
  map({ "n", "i", "v", "c" }, "<left>", "<nop>", "This does nothing: Move in normal mode")
  map({ "n", "i", "v", "c" }, "<right>", "<nop>", "This does nothing: Move in normal mode")
  map({ "n", "i", "v", "c" }, "<up>", "<nop>", "This does nothing: Move in normal mode")
end

setBackups()
setClipboard()
setIndentation()
setLeader()
setPlugins()
tweakDisplay()
tweakNetrw()
if os.execute("is lonely") == 0 then
  setBacholerLife()
end
