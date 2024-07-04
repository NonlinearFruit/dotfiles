-- Misery.nvim <https://github.com/tjdevries/misery.nvim>
local M = {}

local hidden_cursor = {
  name = "hidden cursor",
  start = function()
    vim.cmd [[set guicursor=n-v:hor01-Normal]]
    vim.opt.cursorline = false
    vim.opt.relativenumber = false
    vim.opt.number = false
  end,
  stop = function()
    vim.opt.guicursor = { "n-v-c-sm:block", "i-ci-ve:ver25", "r-cr-o:hor20" }
  end,
}

local invisiline = {
  name = "invisicursor",
  start = function()
    vim.opt.cursorline = true
    vim.opt.list = false
    vim.cmd [[set guicursor=n-v:ver10-Error]]
    vim.cmd [[highlight CursorLine guibg=#111111 guifg=#111111]]
  end,
  stop = function()
    vim.opt.list = true
    vim.cmd.hi "CursorLine guifg=none guibg=#2b2b2b"
    vim.opt.guicursor = { "n-v-c-sm:block", "i-ci-ve:ver25", "r-cr-o:hor20" }
  end,
}

local random_theme = {
  name = "random theme",
  start = function(self)
    local colorschemes = vim.api.nvim_get_runtime_file("colors/*", true)
    colorschemes = vim.tbl_map(function(colorscheme)
      return vim.fn.fnamemodify(colorscheme, ":t:r")
    end, colorschemes)

    local random_colorscheme = colorschemes[math.random(#colorschemes)]
    vim.cmd.hi "clear"
    vim.cmd.colorscheme(random_colorscheme)

    self.state.colorscheme = random_colorscheme
  end,
  done = function()
    vim.cmd.hi "clear"
    vim.cmd.colorscheme "gruvbuddy"
  end,
}

M.getEffects = function()
  return {
    invisiline,
    hidden_cursor,
    random_theme,
  }
end

return M
