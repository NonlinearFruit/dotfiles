-- Misery.nvim <https://github.com/tjdevries/misery.nvim>
-- lua require("prototypes.misery").hit_me()
-- lua require("prototypes.misery").save_me()
local M = {}

local hidden_cursor = {
  name = "hidden cursor",
  desc = "Make the cursor invisible",
  start = function()
    vim.cmd([[set guicursor=n-v:hor01-Normal]])
    vim.opt.cursorline = false
  end,
  stop = function()
    vim.opt.guicursor = { "n-v-c-sm:block", "i-ci-ve:ver25", "r-cr-o:hor20" }
  end,
}

local invisiline = {
  name = "invisiline",
  desc = "Make the current line opaque",
  start = function()
    vim.opt.cursorline = true
    vim.opt.list = false
    vim.cmd([[set guicursor=n-v:ver10-Error]])
    vim.cmd([[highlight CursorLine guibg=#111111 guifg=#111111]])
  end,
  stop = function()
    vim.opt.list = true
    vim.cmd.hi("CursorLine guifg=none guibg=#2b2b2b")
    vim.opt.guicursor = { "n-v-c-sm:block", "i-ci-ve:ver25", "r-cr-o:hor20" }
  end,
}

local random_theme = {
  name = "random theme",
  desc = "Apply random theme from runtime paths",
  start = function()
    local colorschemes = vim.api.nvim_get_runtime_file("colors/*", true)
    colorschemes = vim.tbl_map(function(colorscheme)
      return vim.fn.fnamemodify(colorscheme, ":t:r")
    end, colorschemes)
    colorschemes = vim.tbl_filter(function(colorscheme)
      return colorscheme ~= "README"
    end, colorschemes)

    local random_colorscheme = colorschemes[math.random(#colorschemes)]
    vim.cmd.hi("clear")
    vim.cmd.colorscheme(random_colorscheme)
  end,
  stop = function()
    vim.cmd.hi("clear")
    vim.cmd("NonlinearFruitColorSchemeEnable")
  end,
}

local flip = {
  name = "flip",
  desc = "Change motion directions in normal mode",
  start = function(self)
    local make_map = function(lhs, rhs)
      vim.keymap.set("n", lhs, function()
        print(string.format("typed: %s, executed: %s", lhs, rhs))
        return rhs
      end, { expr = true })
    end

    for _, pair in ipairs(self.pairs) do
      make_map(pair[1], pair[2])
      make_map(pair[2], pair[1])
    end
  end,
  stop = function(self)
    for _, pair in ipairs(self.pairs) do
      pcall(vim.keymap.del, "n", pair[1])
      pcall(vim.keymap.del, "n", pair[2])
    end
  end,
  pairs = {
    { "j", "k" },
    { "w", "b" },
    { "h", "l" },
    { "gg", "G" },
    { "e", "ge" },
    { "f", "F" },
    { "t", "T" },
    { "n", "N" },
    { "?", "/" },
    { "#", "*" },
    { "i", "a" },
    { "I", "A" },
    { ";", "," },
    { "$", "^" },
    { "o", "O" },
    { "y", "p" },
    { "u", "<c-r>" },
    { "<c-o>", "<c-i>" },
    { "<c-u>", "<c-d>" },
  },
}

local right_to_left = {
  name = "tfel-ot-thgir",
  desc = "Flip the text to display right to left",
  start = function()
    for _, window in ipairs(vim.api.nvim_list_wins()) do
      vim.wo[window].rightleft = true
    end
  end,
  stop = function()
    for _, window in ipairs(vim.api.nvim_list_wins()) do
      vim.wo[window].rightleft = false
    end
  end,
}

local different_editor = {
  name = "different editor",
  desc = "Open the current file in another randomly-chosen editor",
  start = function (self)
    local timeout = 5 * 60
    local valid_editors = vim.tbl_filter(function(editor)
      return os.execute("which "..editor) == 0
    end, self.editors)
    local editor = valid_editors[math.random(#valid_editors)]
    local cmd = string.format("terminal timeout %d %s %s", timeout, editor, "%")
    vim.cmd(cmd)
    -- vim.api.nvim_open_term(0, {})
  end,
  stop = function ()
    -- noop
  end,
  editors = {
    "ed",
    "ex",
    "vi",
    "nano",
  },
}

M.effects = {
  invisiline,
  hidden_cursor,
  random_theme,
  flip,
  right_to_left,
  different_editor,
}

M.hit_me = function()
  if M.current_effect then
    print("You are currently suffering under '" .. M.current_effect.name .. "'")
  else
    M.current_effect = M.effects[math.random(#M.effects)]
    print("Enjoy '" .. M.current_effect.name .. "'!")
    M.current_effect:start()
  end
end

M.save_me = function()
  if M.current_effect then
    M.current_effect:stop()
    M.current_effect = nil
    print("You have been freed")
  else
    print("There is no misery")
  end
end

return M
