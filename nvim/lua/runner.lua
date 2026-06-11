-- Inspiration: https://github.com/preservim/vimux
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

M.createIfNoRunner = function()
  local runner = M.getId()
  if runner == "" then
    local job = vim.fn.jobstart("tmux -V", {
      stdout_buffered = true,
      on_stdout = function(_, data)
        local version = data[1]
        if string.sub(version, 6, 8) == "3.0" then
          os.execute("tmux split-window -p 40 -h")
        else
          os.execute("tmux split-window -l 40% -h")
        end
      end,
    })
    vim.fn.jobwait({ job })
    os.execute("tmux last-pane")
    runner = M.getId()
  end
  return runner
end

local function toHexadecimal(str)
  local output = ""
  for i = 1, #str do
    local char = string.sub(str, i, i)
    output = string.format("%s %02x", output, string.byte(char))
  end
  return output
end

M.run = function(cmd)
  local runner = M.createIfNoRunner()
  if runner == "" or cmd == "" then
    return
  end
  local hex_escape = toHexadecimal(cmd)
  os.execute("tmux send-keys -t " .. runner .. " -H " .. hex_escape)
  os.execute("tmux send-keys -t " .. runner .. " ENTER")
end

--- Captures the content of the runner tmux pane.
---
--- @param nth_prompt? integer
---   Controls which command block to return, counting from the current command. The
---   prompt boundary is any line starting with ` $`. The PS1 decoration line
---   immediately before each prompt is excluded.
---
---   - `nil`  — return all captured lines (default)
---   - `0`    — the current prompt line
---   - `1`    — the most recently completed command and its output
---   - `2`    — the second-most-recent command and its output
---
--- @return string[]
M.capture = function(nth_prompt)
  local runner = M.getId()
  local lines = vim.fn.systemlist("tmux capture-pane -p -J -S - -t " .. runner)

  if nth_prompt == nil then
    return lines
  end

  local prompt_indices = {}
  for i, line in ipairs(lines) do
    if line:match("^ %$") then
      table.insert(prompt_indices, i)
    end
  end

  local target = #prompt_indices - nth_prompt
  if target < 1 then
    return {}
  end

  local from = prompt_indices[target]
  local to = target < #prompt_indices and prompt_indices[target + 1] - 2 or #lines

  local result = {}
  for i = from, to do
    table.insert(result, lines[i])
  end
  return result
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
