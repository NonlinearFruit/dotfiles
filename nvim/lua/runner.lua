-- Inspiration: https://github.com/preservim/vimux
local M = {}
local runner_id

local function cache_runner_id(id)
  runner_id = id
  return runner_id
end

local function list_panes()
  local panes = {}
  local pane_query = "#{pane_active}\t#{pane_id}\t#{pane_index}\t#{pane_current_command}"
  local lines = vim.fn.systemlist("tmux list-panes -F '"..pane_query.."'")

  for _, line in ipairs(lines) do
    local fields = vim.split(line, "\t")
    if #fields >= 4 then
      table.insert(panes, {
        active = fields[1] == "1",
        id = fields[2],
        index = fields[3],
        command = fields[4],
      })
    end
  end

  return panes
end

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

M.switch = function()
  local panes = {}
  for _, pane in ipairs(list_panes()) do
    if not pane.active then
      table.insert(panes, pane)
    end
  end

  if #panes == 0 then
    return cache_runner_id(M.createIfNoRunner())
  elseif #panes == 1 then
    return cache_runner_id(panes[1].id)
  end

  local helpers = require("helpers")
  local selection = helpers.pick_one_sync("Select runner pane", panes, function(pane)
    return string.format("%s [%s]", pane.command, pane.index)
  end)

  if selection == nil then
    return M.getId()
  end

  return cache_runner_id(selection.id)
end

M.getId = function()
  local first_non_active_pane = nil
  if runner_id ~= nil then
    for _, pane in ipairs(list_panes()) do
      if pane.id == runner_id then
        return runner_id
      elseif not pane.active and first_non_active_pane == nil then
        first_non_active_pane = pane.id
      end
    end
    runner_id = nil
  end

  if first_non_active_pane == nil then
    return ""
  end

  return cache_runner_id(first_non_active_pane)
end

return M
