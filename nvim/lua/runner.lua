local M = {}

M.close = function()
  local runner = M.getId()
  if runner == "" then
    return
  end
  os.execute("tmux kill-pane -t " .. runner)
end

M.prompt = function()
  local cmd = vim.fn.input("$ ")
  M.run(cmd)
end

M.run = function(cmd)
  local runner = M.getId()
  if runner == "" then
    os.execute("tmux split-window -l 40% -h")
    os.execute("tmux last-pane")
    runner = M.getId()
    if runner == "" then
      return
    end
  end
  os.execute("tmux send-keys -t " .. runner .. " '" .. cmd .. "' ENTER")
end

M.zoom = function()
  local runner = M.getId()
  os.execute("tmux resize-pane -Z -t " .. runner)
end

M.getId = function()
  local panes = vim.fn.systemlist("tmux list-panes -F '#{pane_active}:#{pane_id}'")
  for _, pane in pairs(panes) do
    if string.sub(pane, 1, 1) ~= "1" then
      return string.sub(pane, 3)
    end
  end
  return ""
end

return M
