if vim.g.started_by_firenvim then
  -- turn off some visual clutter
  vim.opt.showtabline = 0
  vim.opt.laststatus = 0
  vim.opt.guifont = "Operator Mono Lig Book:h14"
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
    ['.*outlook.office365.com/mail.*'] = {
      takeover = 'always',
      priority = 0,
      selector = '#ReadingPaneContainerId [aria-label="Message body, press Alt+F10 to exit"]'
    },
    [".*"] = {
      takeover = 'always',
      priority = 0
    }
  }
}
