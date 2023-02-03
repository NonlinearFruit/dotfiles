require('plugins')

-- Indentaion should be two spaces. Tabs shouldn't exist
vim.opt.tabstop = 2
vim.opt.softtabstop  = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Other
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true

-- Backups
vim.opt.swapfile = true
vim.opt.directory = os.getenv("HOME") .. "/.vim/swapfiles"
vim.opt.backup = true
vim.opt.backupdir = os.getenv("HOME") .. "/.vim/backupfiles"
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undofiles"

-- Use the Windows clipboard
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

-- Remove newbie crutches!
vim.keymap.set({"n", "i", "v", "c"}, "<bs>", "<nop>")
vim.keymap.set({"n", "i", "v", "c"}, "<del>", "<nop>")
vim.keymap.set({"n", "i", "v", "c"}, "<down>", "<nop>")
vim.keymap.set({"n", "i", "v", "c"}, "<left>", "<nop>")
vim.keymap.set({"n", "i", "v", "c"}, "<right>", "<nop>")
vim.keymap.set({"n", "i", "v", "c"}, "<up>", "<nop>")
-- vim.keymap.set({"n", "i", "v", "c"}, "hh", "<nop>")
-- vim.keymap.set({"n", "i", "v", "c"}, "jj", "<nop>")
-- vim.keymap.set({"n", "i", "v", "c"}, "kk", "<nop>")
-- vim.keymap.set({"n", "i", "v", "c"}, "ll", "<nop>")
