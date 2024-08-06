local api = vim.api
local typewriter_active = false

local function center_cursor()
	if not typewriter_active then
		return
	end
	api.nvim_command("normal! zzzszH")
end

local function enable_typewriter_mode()
	if not typewriter_active then
		typewriter_active = true
    local group = vim.api.nvim_create_augroup("typewriter", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      callback = center_cursor,
    })
	end
end

local function disable_typewriter_mode()
	if typewriter_active then
		typewriter_active = false
		api.nvim_command("autocmd! typewriter")
	end
end

local function configure()
	api.nvim_create_user_command("TypewriterEnable", enable_typewriter_mode, {})
	api.nvim_create_user_command("TyperwriterDisable", disable_typewriter_mode, {})
end

return {
  "prototypes/typewriter",
  config = configure,
  dev = true,
}
