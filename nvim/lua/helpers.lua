local M = {}
M.get_selected_text = function()
  local register = '"'
  -- Backup register
  local old_text = vim.fn.getreg(register)
  local old_regtype = vim.fn.getregtype(register)
  -- Get selection
  vim.cmd('normal! "' .. register .. "y")
  local selected_text = vim.fn.getreg(register)
  -- Restore register
  vim.fn.setreg(register, old_text, old_regtype)
  return selected_text
end
return M
