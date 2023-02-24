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
  -- at least 5 lines
  vim.api.nvim_create_autocmd("BufEnter", { group = firenvimMappings, pattern = { "*.txt" }, callback = function() if vim.go.lines < 5 then vim.go.lines = 5 end end})
  vim.keymap.set("n", "<esc><esc><esc>", ":call firenvim#focus_page()<cr>")
  vim.keymap.set("n", "<c-z>", ":call firenvim#hide_frame()<cr>")
  vim.keymap.set({"n", "i"}, "<s-cr>", [[<esc><cmd>w | call firenvim#eval_js('document.querySelectorAll("button.c-wysiwyg_container__button--send:not(.c-wysiwyg_container__button--disabled)")[0].click()') | q<cr>]])
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
