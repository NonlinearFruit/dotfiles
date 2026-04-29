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
  stop = function() -- Does not fully undo the changes
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
  stop = function() -- Does not fully undo the changes
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

local flip_bindings = {
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
  -- augroup = "misery.differen_editor",
  start = function(self)
    local timeout = 5 * 60
    local valid_editors = vim.tbl_filter(function(editor)
      return os.execute("which " .. editor) == 0
    end, self.editors)
    local editor = valid_editors[math.random(#valid_editors)]
    local cmd = string.format("terminal timeout %d %s %s", timeout, editor, "%")
    -- local group = vim.api.nvim_create_augroup(self.augroup, { clear = true })
    -- -- autocmd TermOpen * startinsert
    -- vim.api.nvim_create_autocmd("TermOpen", {
    --   group = group,
    --   command = "startinsert",
    -- })
    vim.cmd(cmd)
    -- vim.api.nvim_open_term(0, {})
  end,
  stop = function(self)
    -- vim.api.nvim_clear_autocmds({ group = self.augroup })
  end,
  editors = {
    "ed",
    "ex",
    "vi",
    "nano",
  },
}

local crutchless = {
  name = "crutchless",
  desc = "Disable noobie crutches",
  start = function()
    local function map(key)
      vim.keymap.set({ "n", "i", "v", "c" }, key, "<nop>", {})
    end
    map("<bs>")
    map("<del>")
    map("<down>")
    map("<left>")
    map("<right>")
    map("<up>")
  end,
  stop = function()
    local function unmap(key)
      vim.keymap.del({ "n", "i", "v", "c" }, key)
    end
    unmap("<bs>")
    unmap("<del>")
    unmap("<down>")
    unmap("<left>")
    unmap("<right>")
    unmap("<up>")
  end,
  keys = {
    "<bs>",
    "<del>",
    "<down>",
    "<left>",
    "<right>",
    "<up>",
  },
}

local deranged_register = {
  name = "deranged register",
  desc = "Every yank lands in a random register, the default registers are always empty",
  augroup = "misery.chaos_register",
  registers = "abcdefghijklmnopqrstuvwxyz",
  start = function(self)
    local group = vim.api.nvim_create_augroup(self.augroup, { clear = true })
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = group,
      callback = function()
        local ev = vim.v.event
        local registers = "abcdefghijklmnopqrstuvwxyz"
        local i = math.random(#registers)
        local reg = registers:sub(i, i)
        vim.fn.setreg(reg, ev.regcontents, ev.regtype)
        vim.notify(string.format('yanked into "%s', reg), vim.log.levels.WARN)
        -- Clear the default yank registers so that a plain `p` does not work
        vim.fn.setreg('"', "")
        vim.fn.setreg("0", "")
      end,
    })
  end,
  stop = function(self)
    vim.api.nvim_clear_autocmds({ group = self.augroup })
  end,
}

local lvl = vim.diagnostic.severity
local hysteric_diagnostics = {
  name = "hysteric diagnostics",
  desc = "Inject fake diagnostics",
  namespace = vim.api.nvim_create_namespace("misery.hysteric_diagnostics"),
  augroup = "misery.hysteric_diagnostics",
  timer = nil,
  messages = {
    { severity = lvl.ERROR, message = "syntax error, try once more with feeling" },
    { severity = lvl.ERROR, message = "unreachable code, unachievable dreams" },
    {
      severity = lvl.HINT,
      message = "possible null reference, reconsider the choices that have brought you to this moment",
    },
    { severity = lvl.WARN, message = "this variable is shadowed by its own ambition" },
    -- From Alan Perlis <https://www.cs.yale.edu/homes/perlis-alan/quotes.html>
    { severity = lvl.ERROR, message = "it is often the early bird that makes the worm" },
    { severity = lvl.ERROR, message = "simplicity does not precede complexity, but follows it" },
    { severity = lvl.ERROR, message = "there are two ways to write error-free programs; only the third way works" },
    {
      severity = lvl.HINT,
      message = "is it possible that software is not like anything else, that it is meant to be discarded: that the whole point is to see it as a soap bubble?",
    },
    { severity = lvl.HINT, message = "it is easier to change the specification to fit the program than vice versa" },
    { severity = lvl.HINT, message = "it is easier to write an incorrect program than understand a correct one" },
    { severity = lvl.HINT, message = "the proof of a system's value is its existence" },
    {
      severity = lvl.HINT,
      message = "there will always be things we wish to say in our programs that in all known languages can only be said poorly",
    },
    { severity = lvl.WARN, message = "in seeking the unattainable, simplicity only gets in the way" },
    { severity = lvl.WARN, message = "one man's constant is another man's variable" },
    { severity = lvl.WARN, message = "optimization hinders evolution" },
    { severity = lvl.WARN, message = "string is a perfect vehicle for hiding information" },
    { severity = lvl.WARN, message = "syntactic sugar causes cancer of the semicolon" },
  },
  start = function(self)
    local function sprinkle()
      local buf = vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local line_count = vim.api.nvim_buf_line_count(buf)
      if line_count == 0 then
        return
      end
      local diagnostics = {}
      local count = math.random(1, 3)
      for _ = 1, count do
        local pick = self.messages[math.random(#self.messages)]
        local lnum = math.random(0, line_count - 1)
        local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1] or ""
        table.insert(diagnostics, {
          lnum = lnum,
          col = 0,
          end_lnum = lnum,
          end_col = #line,
          severity = pick.severity,
          message = pick.message,
          source = self.name,
        })
      end
      vim.diagnostic.set(self.namespace, buf, diagnostics)
    end

    self.timer = vim.uv.new_timer()
    self.timer:start(2000, 30000, vim.schedule_wrap(sprinkle))

    local group = vim.api.nvim_create_augroup(self.augroup, { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
      group = group,
      callback = function()
        if math.random() < 0.3 then
          sprinkle()
        end
      end,
    })
  end,
  stop = function(self)
    if self.timer then
      self.timer:stop()
      self.timer:close()
      self.timer = nil
    end
    pcall(vim.api.nvim_clear_autocmds, { group = self.augroup })
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.diagnostic.reset(self.namespace, buf)
      end
    end
  end,
}

M.effects = {
  invisiline,
  hysteric_diagnostics,
  deranged_register,
  hidden_cursor,
  random_theme,
  flip_bindings,
  right_to_left,
  different_editor,
  crutchless,
}

M.hit_me = function(optional_effect_name)
  if M.current_effect then
    print("You are currently suffering under '" .. M.current_effect.name .. "'")
    return
  end
  if optional_effect_name then
    local effects_with_name = vim.tbl_filter(function(effect)
      return effect.name == optional_effect_name
    end, M.effects)
    M.current_effect = effects_with_name[1]
  else
    M.current_effect = M.effects[math.random(#M.effects)]
  end
  print("Enjoy '" .. M.current_effect.name .. "'!")
  M.current_effect:start()
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
