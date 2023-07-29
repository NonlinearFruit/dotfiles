-- :checkhealth

require("plugins")

-- Leader Key
vim.g.mapleader = " "

-- Indentaion should be two spaces. Tabs shouldn't exist
vim.opt.tabstop = 2
vim.opt.softtabstop  = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Display
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = false
vim.api.nvim_command("hi LineNr guifg=grey ctermfg=grey")
vim.api.nvim_command("hi Pmenu guibg=black ctermbg=black guifg=white ctermfg=white") -- Make popup windows not pink (https://vi.stackexchange.com/a/12665/11897)
vim.cmd.colorscheme("habamax")
vim.cmd("highlight clear SignColumn")

-- Netrw
vim.g.netrw_banner=0 -- Hide banner
vim.g.netrw_liststyle=3 -- Tree view
vim.g.netrw_preview=0 -- Preview below

-- Backups
vim.opt.swapfile = true
vim.opt.directory = os.getenv("HOME") .. "/.nvim/swapfiles"
vim.opt.backup = true
vim.opt.backupdir = os.getenv("HOME") .. "/.nvim/backupfiles"
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undofiles"

if string.find(vim.loop.os_uname().release, 'microsoft') then
  vim.g.clipboard = {
        name = 'WslClipboard',
        copy= {
              ['+'] = 'clip.exe',
              ['*'] = 'clip.exe',
        },
        paste = {
              ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0
  }
else
  vim.g.clipboard = {
        name = 'LinuxClipboard',
        copy= {
              ['+'] = 'xclip -sel clip',
              ['*'] = 'xclip -sel clip',
        },
        paste = {
              ['+'] = 'xclip -sel clip -o',
              ['*'] = 'xclip -sel clip -o',
        },
        cache_enabled = 0
  }
end

local function map(mode, key, cmd, description)
  vim.keymap.set(mode, key, cmd, { desc = description })
end

-- Remove obnoxious bindings
map({"n", "i"}, "<f1>", "<nop>", "This does nothing: Too close to Esc")

-- Remove newbie crutches!
map({"n", "i", "v", "c"}, "<bs>", "<nop>", "This does nothing: Edit in normal mode")
map({"n", "i", "v", "c"}, "<del>", "<nop>", "This does nothing: Edit in normal mode")
map({"n", "i", "v", "c"}, "<down>", "<nop>", "This does nothing: Move in normal mode")
map({"n", "i", "v", "c"}, "<left>", "<nop>", "This does nothing: Move in normal mode")
map({"n", "i", "v", "c"}, "<right>", "<nop>", "This does nothing: Move in normal mode")
map({"n", "i", "v", "c"}, "<up>", "<nop>", "This does nothing: Move in normal mode")
-- map({"n", "v", "c"}, "hh", "<nop>", "This does nothing: Use relative jumps")
-- map({"n", "v", "c"}, "jj", "<nop>", "This does nothing: Use relative jumps")
-- map({"n", "v", "c"}, "kk", "<nop>", "This does nothing: Use relative jumps")
-- map({"n", "v", "c"}, "ll", "<nop>", "This does nothing: Use relative jumps")

-- File type mappings
local fileTypeMappings = vim.api.nvim_create_augroup("FileTypeMappings", {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {
  group = fileTypeMappings,
  pattern = { '*.page' },
  callback = function ()
    vim.bo.filetype = 'markdown'
  end
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = fileTypeMappings,
  pattern = { '*.crontab' },
  callback = function ()
    vim.bo.filetype = 'crontab'
  end
})
