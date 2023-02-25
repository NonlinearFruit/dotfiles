local SetupBuffer = function()
  local bufferName = vim.api.nvim_buf_get_name(0)
  local bufferLines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  -- At least 5 lines big
  if vim.go.lines < 5 then vim.go.lines = 5 end

  -- Occassionally helpful generic maps
  vim.keymap.set("n", "<esc><esc><esc>", ":call firenvim#focus_page()<cr>")
  vim.keymap.set({"n", "i"}, "<c-z>", ":call firenvim#hide_frame()<cr>")

  -- Start in insert mode if we're an empty buffer
  if bufferName ~= "" and bufferLines[1] == "" then
    vim.cmd([[startinsert]])
  end

  -- Maps to send messages
  if string.find(bufferName, "slack") then
    vim.keymap.set({"n", "i"}, "<s-cr>", [[<esc><cmd>w | call firenvim#eval_js('document.querySelectorAll("button.c-wysiwyg_container__button--send:not(.c-wysiwyg_container__button--disabled)")[0].click()') | q<cr>]])
  elseif  string.find(bufferName, "linodeusercontent") then
    vim.keymap.set({"n", "i"}, "<s-cr>", [[<esc><cmd>w | call firenvim#eval_js('document.querySelectorAll(".rc-input__icon-svg--send")[0].dispatchEvent( new Event( "click", { bubbles: true } ) )') | q<cr>]])
  else
    vim.keymap.set({"n", "i"}, "<s-cr>", [[<esc><cmd>w | call firenvim#press_keys("<LT>C-CR>") | q<cr>]])
  end

end

if vim.g.started_by_firenvim then
  -- turn off some visual clutter
  vim.opt.guifont = "Operator Mono Lig Book:h14"
  vim.opt.laststatus = 0
  vim.opt.ruler = false
  vim.opt.showcmd = false
  vim.opt.showtabline = 0
  vim.opt.signcolumn = 'no'
  vim.opt.wrap = true
  vim.opt.spell = true
  vim.bo.filetype = 'markdown'

  local firenvimMappings = vim.api.nvim_create_augroup("FirenvimMappings", {clear = true})
  vim.api.nvim_create_autocmd("BufEnter", { group = firenvimMappings, callback = SetupBuffer})
end

local ignore = {
  takeover = 'never',
  priority = 1
}

vim.g.firenvim_config = {
  localSettings = {
    ['.*sourcegraph.com.*'] = ignore,
    ['.*regexr.com.*'] = ignore,
    ['.*teams.microsoft.com.*'] = ignore,
    ['.*docs.google.com.*'] = ignore,
    ['.*outlook.office365.com/mail.*'] = {
      takeover = 'always',
      priority = 0,
      selector = '#ReadingPaneContainerId [aria-label="Message body, press Alt+F10 to exit"]'
    },
    ['.*outlook.office365.com/calendar.*'] = {
      takeover = 'always',
      priority = 0,
      selector = ':not(.EditorClass)[role="textbox"] '
    },
    [".*"] = {
      takeover = 'always',
      priority = 0
    }
  }
}

-- NOTES
-- Slack :: Preference > Advanced > Use Markup editor
