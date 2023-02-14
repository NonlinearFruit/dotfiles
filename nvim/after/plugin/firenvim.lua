if vim.g.started_by_firenvim then
  -- turn off some visual clutter
  vim.opt.guifont = "Operator Mono Lig Book:h14"
  vim.opt.laststatus = 0
  vim.opt.ruler = false
  vim.opt.showcmd = false
  vim.opt.showtabline = 0
  vim.opt.signcolumn = 'no'
  vim.bo.filetype = 'markdown'
  local firenvimMappings = vim.api.nvim_create_augroup("FirenvimMappings", {clear = true})
  vim.api.nvim_create_autocmd("BufEnter", { group = firenvimMappings, pattern = { "*.txt" }, callback = function() if vim.go.lines < 5 then vim.go.lines = 5 end end})
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
    [".*slack.com.*"] = {
      takeover = 'once',
      priority = 0
    },
    [".*"] = {
      takeover = 'always',
      priority = 0
    }
  }
}

-- NOTES
-- Slack :: Preference > Advanced > Use Markup editor
