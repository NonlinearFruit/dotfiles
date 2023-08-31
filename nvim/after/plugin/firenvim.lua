if not packer_plugins["firenvim"] or not packer_plugins["firenvim"].loaded then
  return
end

local SetupBuffer = function()
  local bufferName = vim.api.nvim_buf_get_name(0)
  local bufferLines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  -- At least 5 lines big
  if vim.go.lines < 5 then
    vim.go.lines = 5
  end

  local function map(mode, key, cmd, description)
    vim.keymap.set(mode, key, cmd, { desc = description })
  end

  -- Occassionally helpful generic maps
  map("n", "<esc><esc><esc>", ":call firenvim#focus_page()<cr>", "Focus webpage")
  map({ "n", "i" }, "<c-z>", ":call firenvim#hide_frame()<cr>", "Hide firenvim")

  -- Start in insert mode if we're an empty buffer
  if bufferName ~= "" and bufferLines[1] == "" then
    vim.cmd([[startinsert]])
  end

  -- Maps to send messages
  local hotKeyToShipIt = "<c-cr>"
  if string.find(bufferName, "slack") then
    map({ "n" }, "=", [[<cmd>%s#<p><br></p>#\r#ge | %s#</p>\(<p>\)\?#\r#ge | %s#<p>##e<cr>]], "Format slack html")
    map(
      { "n", "i" },
      hotKeyToShipIt,
      [[<esc><cmd>%s#\n#</p><p>#ge | 1s#^#<p>#e | $s#<p>$## | w | call firenvim#eval_js('document.querySelectorAll("button.c-wysiwyg_container__button--send:not(.c-wysiwyg_container__button--disabled)")[0].click()') | q<cr>]],
      "Ship it!"
    )
  elseif string.find(bufferName, "linodeusercontent") then
    map(
      { "n", "i" },
      hotKeyToShipIt,
      [[<esc><cmd>w | call firenvim#eval_js('document.querySelectorAll(".rc-input__icon-svg--send")[0].dispatchEvent( new Event( "click", { bubbles: true } ) )') | q<cr>]],
      "Ship it!"
    )
  else
    map({ "n", "i" }, hotKeyToShipIt, "<esc><cmd>wq<cr>", "Ship it!")
  end
end

if vim.g.started_by_firenvim then
  -- turn off some visual clutter
  vim.opt.guifont = "Operator Mono Lig Book:h14"
  vim.opt.laststatus = 0
  vim.opt.ruler = false
  vim.opt.showcmd = false
  vim.opt.showtabline = 0
  vim.opt.signcolumn = "no"
  vim.opt.wrap = true
  vim.opt.spell = true
  vim.bo.filetype = "markdown"

  local firenvimMappings = vim.api.nvim_create_augroup("FirenvimMappings", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", { group = firenvimMappings, callback = SetupBuffer })
end

local nf_ok, nf = pcall(require, "nonlinearfruit")
local localSettings = {}
if nf_ok then
  localSettings = nf.firenvim_localSettings
end

vim.g.firenvim_config = {
  localSettings = localSettings,
  globalSettings = {
    ignoreKeys = {
      all = {
        "<C-W>",
        "<F1>",
        "<F2>",
        "<F3>",
        "<F4>",
        "<F5>",
        "<F12>",
        "<SC-P>",
      },
    },
  },
}

-- NOTES
-- Slack :: Preference > Advanced > Use Markup editor
