local M = {}
local is_running = false -- true if jqplay session running, false otherwise
local in_buf = -1 -- input buffer number (optional)
local in_changedtick = -1 -- b:changedtick of input buffer (optional)
local in_timer = 0 -- timer-ID of input buffer (optional)
local filter_buf = 0 -- filter buffer number
local filter_changedtick = 0 -- b:changedtick of filter buffer
local filter_timer = 0 -- timer-ID of filter buffer
local filter_file = "" -- full path to filter file on disk
local out_buf = 0 -- output buffer number
local jq_cmd = "" -- jq command running on buffer change
local job_id = "" -- job object of jq process
local defaults = {
  exe = vim.fn.exepath("jq"),
  opts = "",
  delay = 500,
  autocmds = { "InsertLeave", "TextChanged" },
}

local function Jqcmd(exe, opts, args, file)
  args = args or ""
  return exe .. " " .. opts .. " " .. args .. " -f " .. file
end

-- Is jqplay session running with input buffer?
local function Jq_with_input()
  return in_buf ~= -1
end

local function New_scratch(bufname, filetype, clean, mods, opts)
  opts = opts or {}
  mods = mods or ""
  local winid = vim.fn.win_getid()
  local bufnr = ""

  if vim.fn.bufexists(bufname) ~= 0 then
    bufnr = vim.fn.bufnr(bufname)
    vim.fn.setbufvar(bufnr, "&filetype", filetype)
    if clean then
      vim.fn.deletebufline(bufnr, 1, "$")
    end

    if vim.fn.bufwinnr(bufnr) > 0 then
      return bufnr
    else
      vim.fn.execute("sbuffer " .. bufnr)
    end
  else
    vim.fn.execute("new " .. vim.fn.fnameescape(bufname))
    vim.opt_local.swapfile = false
    vim.opt_local.buflisted = true
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "hide"
    bufnr = vim.fn.bufnr()
    vim.fn.setbufvar(bufnr, "&filetype", filetype)
  end

  if opts["resize"] then
    vim.fn.execute("resize" .. opts.resize)
  end

  vim.fn.win_gotoid(winid)

  return bufnr
end

local function Close_cb(ch)
  vim.fn.deletebufline(out_buf, 1)
  vim.cmd("redrawstatus")
end

local function isJobRunning(id)
  return vim.fn.jobwait({ id }, 0)[0] == -1
end

local function Run_jq(cmd)
  vim.fn.deletebufline(out_buf, 1, "$")

  if vim.fn.exists(job_id) and isJobRunning(job_id) then
    vim.fn.job_stop(job_id)
  end

  local opts = {
    stdin = "null",
    on_stdout = function(_, msg)
      local output = table.concat(msg, "\n")
      vim.fn.appendbufline(out_buf, "$", msg)
    end,
    on_stderr = function(_, msg)
      if msg[1] == "" then
        return
      end
      local output = table.concat(msg, "\n")
      vim.fn.appendbufline(out_buf, "$", "// " .. msg)
      vim.fn.appendbufline(out_buf, "$", "// " .. jq_cmd)
    end,
    on_exit = Close_cb,
  }

  if Jq_with_input() then
    opts.stdin = "pipe"
  end

  job_id = vim.fn.jobstart(cmd, opts)

  if Jq_with_input() then
    local input = vim.fn.getbufline(in_buf, 1, "$")
    vim.fn.chansend(job_id, input)
    vim.fn.chanclose(job_id, "stdin")
  end
end

local function Run_manually(bang, args)
  if filter_changedtick ~= vim.fn.getbufvar(filter_buf, "changedtick") then
    vim.fn.writefile(vim.fn.getbufline(filter_buf, 1, "$"), filter_file)
  end

  local cmd = Jqcmd(defaults["exe"], defaults["opts"], args, filter_file)
  Run_jq(cmd)

  if bang then
    jq_cmd = cmd
  end
end

local function Filter_changed(timer)
  vim.fn.writefile(vim.fn.getbufline(filter_buf, 1, "$"), filter_file)
  Run_jq(jq_cmd)
end

local function On_filter_changed()
  if filter_changedtick == vim.fn.getbufvar(filter_buf, "changedtick") then
    return
  end

  filter_changedtick = vim.fn.getbufvar(filter_buf, "changedtick")
  vim.fn.timer_stop(filter_timer)
  filter_timer = vim.fn.timer_start(defaults["delay"], Filter_changed)
end

local function On_input_changed()
  if in_changedtick == vim.fn.getbufvar(in_buf, "changedtick") then
    return
  end

  in_changedtick = vim.fn.getbufvar(in_buf, "changedtick")
  vim.fn.timer_stop(in_timer)
  in_timer = vim.fn.timer_start(defaults["delay"], function(_)
    Run_jq(jq_cmd)
  end)
end

local function Jq_stop(arg)
  arg = arg or "term"
  if isJobRunning(job_id) == "run" then
    vim.fn.job_stop(job_id, arg)
  end
end

local function Jq_close(bang)
  if not is_running and not (vim.fn.exists("#jqplay#BufDelete") or vim.fn.exists("#jqplay#BufWipeout")) then
    return
  end

  Jq_stop()
  vim.api.nvim_clear_autocmds({ group = "jqplay" })

  if bang then
    vim.fn.execute("bwipeout" .. filter_buf)
    vim.fn.execute("bwipeout" .. out_buf)
    if Jq_with_input() and vim.fn.getbufvar(in_buf, "&buftype") == "nofile" then
      vim.fn.execute("bwipeout" .. in_buf)
    end
  end

  is_running = false
end

-- When 'in_buffer' is set to -1, no input buffer is passed to jq
M.Start = function(mods, args, in_buffer)
  if is_running then
    return
  end

  is_running = true
  in_buf = in_buffer

  -- Check if -r/--raw-output or -j/--join-output options are passed
  local out_ft = "json"

  -- Output buffer
  local out_name = in_buffer == -1 and "jq-output://" or "jq-output://" .. vim.fn.bufname(in_buffer)
  out_buf = New_scratch(out_name, out_ft, true, mods)

  -- jq filter buffer
  local filter_name = in_buffer == -1 and "jq-filter://" or "jq-filter://" .. vim.fn.bufname(in_buffer)
  filter_buf = New_scratch(filter_name, "jq", false, "botright", { resize = 10 })

  -- Temporary file where jq filter buffer is written to
  filter_file = vim.fn.tempname()

  in_changedtick = vim.fn.getbufvar(in_buffer, "changedtick", -1)
  filter_changedtick = vim.fn.getbufvar(filter_buf, "changedtick")
  in_timer = 0
  filter_timer = 0
  jq_cmd = Jqcmd(defaults["exe"], defaults["opts"], args, filter_file)

  -- When input, output or filter buffer are deleted/wiped out, close the
  -- interactive session
  local jqplay = vim.api.nvim_create_augroup("jqplay", { clear = true })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = jqplay,
    buffer = out_buf,
    callback = function()
      Jq_close(false)
    end,
  })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = jqplay,
    buffer = filter_buf,
    callback = function()
      Jq_close(false)
    end,
  })

  if Jq_with_input() then
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
      group = jqplay,
      buffer = in_buf,
      callback = function()
        Jq_close(false)
      end,
    })
  end

  -- Run jq interactively when input or filter buffer are modified
  local events = defaults["autocmds"]

  if next(events) == nil then
    return
  end

  vim.api.nvim_create_autocmd(events, {
    group = jqplay,
    buffer = filter_buf,
    callback = function()
      On_filter_changed()
    end,
  })

  if Jq_with_input() then
    vim.api.nvim_create_autocmd(events, {
      group = jqplay,
      buffer = vim.fn.bufnr(),
      callback = function()
        On_input_changed()
      end,
    })
  end
end

local function Scratch(input, mods, args)
  local raw_input = false -- args =~ '\%(^\|\s\)-\a*R\a*\>\|--raw-input\>'
  local null_input = false -- args =~ '\%(^\|\s\)-\a*n\a*\>\|--null-input\>'

  if input then
    vim.cmd("tabnew")
    vim.opt_local.swapfile = false
    vim.opt_local.buflisted = true
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "hide"

    if not raw_input then
      vim.opt_local.filetype = "json"
    end
  else
    vim.cmd("tab split")
  end

  local arg = not input and not null_input and (args .. " -n") or args
  local bufnr = input and vim.fn.bufnr() or -1
  M.Start(mods, arg, bufnr)

  -- Close the initial window that we opened with :tab split
  if not input then
    vim.cmd("close")
  end
end

return M
