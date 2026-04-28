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

-- https://github.com/mfussenegger/nvim-dap/blob/66d33b7585b42b7eac20559f1551524287ded353/lua/dap/ui.lua#L42C1-L52C4
function M.pick_one_sync(prompt, items, label_fn)
  label_fn = label_fn or function(item)
    return item
  end
  local choices = { prompt }
  for i, item in ipairs(items) do
    table.insert(choices, string.format("%d: %s", i, label_fn(item)))
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #items then
    return nil
  else
    return items[choice]
  end
end

return M
