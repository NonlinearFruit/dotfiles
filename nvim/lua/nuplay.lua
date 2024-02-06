local M = {}

local defaults = {
  exe = vim.fn.exepath("nu"),
  opts = "--stdin",
  delay = 500,
  autocmds = { "InsertLeave", "TextChanged" },
  is_running = false, -- true if nuplay session running, false otherwise
  job_id = "", -- job object of nu process
  cmd = "", -- nu command running on buffer change
  inn = {
    ft = "json",
    buf = -1, -- input buffer number (optional)
    changedtick = -1, -- b:changedtick of input buffer (optional)
    timer = 0, -- timer-ID of input buffer (optional)
  },
  filter = {
    ft = "nu",
    buf = 0, -- filter buffer number
    changedtick = 0, -- b:changedtick of filter buffer
    timer = 0, -- timer-ID of filter buffer
    file = "", -- full path to filter file on disk
  },
  out = {
    ft = "json",
    buf = 0, -- output buffer number
  },
}

local function generate_command(exe, opts, file)
  return exe .. " " .. opts .. " " .. file
end

-- Is nuplay session running with input buffer?
local function is_session_running_with_input_buffer()
  return defaults.inn.buf ~= -1
end

local function new_scratch_buffer(bufname, filetype, clean, opts)
  opts = opts or {}
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

local function clear_output_buffer(_)
  vim.fn.deletebufline(defaults.out.buf, 1)
  vim.cmd("redrawstatus")
end

local function is_job_running(id)
  return vim.fn.jobwait({ id }, 0)[0] == -1
end

local function update_output_buffer()
  local cmd = defaults.cmd
  vim.fn.deletebufline(defaults.out.buf, 1, "$")

  if vim.fn.exists(defaults.job_id) and is_job_running(defaults.job_id) then
    vim.fn.job_stop(defaults.job_id)
  end

  local opts = {
    stdin = "null",
    on_stdout = function(_, msg)
      vim.fn.appendbufline(defaults.out.buf, "$", msg)
    end,
    on_stderr = function(_, msg)
      if msg[1] == "" then
        return
      end
      vim.fn.appendbufline(defaults.out.buf, "$", msg)
      vim.fn.appendbufline(defaults.out.buf, "$", "// " .. defaults.cmd)
    end,
    on_exit = clear_output_buffer,
  }

  if is_session_running_with_input_buffer() then
    opts.stdin = "pipe"
  end

  defaults.job_id = vim.fn.jobstart(cmd, opts)

  if is_session_running_with_input_buffer() then
    local input = vim.fn.getbufline(defaults.inn.buf, 1, "$")
    vim.fn.chansend(defaults.job_id, input)
    vim.fn.chanclose(defaults.job_id, "stdin")
  end
end

local function update_filter_buffer()
  vim.fn.writefile(vim.fn.getbufline(defaults.filter.buf, 1, "$"), defaults.filter.file)
  update_output_buffer()
end

local function on_buffer_changed(defaultsSection, update_function)
  if defaultsSection.changedtick == vim.fn.getbufvar(defaultsSection.buf, "changedtick") then
    return
  end

  defaultsSection.changedtick = vim.fn.getbufvar(defaultsSection.buf, "changedtick")
  vim.fn.timer_stop(defaultsSection.timer)
  defaultsSection.timer = vim.fn.timer_start(defaults.delay, update_function)
end

local function stop(arg)
  arg = arg or "term"
  if is_job_running(defaults.job_id) == "run" then
    vim.fn.job_stop(defaults.job_id, arg)
  end
end

local function close(bang)
  if not defaults.is_running and not (vim.fn.exists("#nuplay#BufDelete") or vim.fn.exists("#nuplay#BufWipeout")) then
    return
  end

  stop()
  vim.api.nvim_clear_autocmds({ group = "nuplay" })

  if bang then
    vim.fn.execute("bwipeout" .. defaults.filter.buf)
    vim.fn.execute("bwipeout" .. defaults.out.buf)
    if is_session_running_with_input_buffer() and vim.fn.getbufvar(defaults.inn.buf, "&buftype") == "nofile" then
      vim.fn.execute("bwipeout" .. defaults.inn.buf)
    end
  end

  defaults.is_running = false
end

-- When 'in_buffer' is set to -1, no input buffer is passed to nu
M.start = function()
  if defaults.is_running then
    return
  end
  defaults.is_running = true
  local in_buffer = vim.fn.bufnr()
  defaults.inn.buf = in_buffer

  -- Output buffer
  local out_name = in_buffer == -1 and "nu-output://" or "nu-output://" .. vim.fn.bufname(in_buffer)
  defaults.out.buf = new_scratch_buffer(out_name, defaults.out.ft, true)

  -- nu filter buffer
  local filter_name = in_buffer == -1 and "nu-filter://" or "nu-filter://" .. vim.fn.bufname(in_buffer)
  defaults.filter.buf = new_scratch_buffer(filter_name, defaults.filter.ft, false, "botright")

  -- Temporary file where nu filter buffer is written to
  defaults.filter.file = vim.fn.tempname()

  defaults.inn.changedtick = vim.fn.getbufvar(in_buffer, "changedtick", -1)
  defaults.filter.changedtick = vim.fn.getbufvar(defaults.filter.buf, "changedtick")
  defaults.inn.timer = 0
  defaults.filter.timer = 0
  defaults.cmd = generate_command(defaults.exe, defaults.opts, defaults.filter.file)

  -- When input, output or filter buffer are deleted/wiped out, close the
  -- interactive session
  local nuplay = vim.api.nvim_create_augroup("nuplay", { clear = true })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = nuplay,
    buffer = defaults.out.buf,
    callback = function()
      close(false)
    end,
  })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = nuplay,
    buffer = defaults.filter.buf,
    callback = function()
      close(false)
    end,
  })

  if is_session_running_with_input_buffer() then
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
      group = nuplay,
      buffer = defaults.inn.buf,
      callback = function()
        close(false)
      end,
    })
  end

  -- Run nu interactively when input or filter buffer are modified
  local events = defaults.autocmds

  if next(events) == nil then
    return
  end

  vim.api.nvim_create_autocmd(events, {
    group = nuplay,
    buffer = defaults.filter.buf,
    callback = function()
      on_buffer_changed(defaults.filter, update_filter_buffer)
    end,
  })

  if is_session_running_with_input_buffer() then
    vim.api.nvim_create_autocmd(events, {
      group = nuplay,
      buffer = vim.fn.bufnr(),
      callback = function()
        on_buffer_changed(defaults.inn, update_output_buffer)
      end,
    })
  end
end

return M
