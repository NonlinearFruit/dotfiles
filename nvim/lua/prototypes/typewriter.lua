local api = vim.api

local M = {}

local typewriter_active = false

local function center_cursor()
	if not typewriter_active then
		return
	end
	-- Center the screen around the cursor without moving the cursor
	api.nvim_command("normal! zzzszH")
end

local function enable_typewriter_mode()
	if not typewriter_active then
		typewriter_active = true
		-- Set autocommands for normal, insert, and visual modes
		api.nvim_command('autocmd CursorMoved,CursorMovedI * lua require("prototypes.typewriter").center_cursor()')
	end
end

local function disable_typewriter_mode()
	if typewriter_active then
		typewriter_active = false
		-- Clear the autocommand group for TypewriterMode
		api.nvim_command("autocmd! TypewriterMode")
	end
end

local function setup()
	api.nvim_command("augroup TypewriterMode")
	api.nvim_command("autocmd!")
	api.nvim_command("augroup END")
	api.nvim_create_user_command("TWEnable", enable_typewriter_mode, {})
	api.nvim_create_user_command("TWDisable", disable_typewriter_mode, {})
end

M.setup = setup
M.center_cursor = center_cursor
M.enable = enable_typewriter_mode
M.disable = disable_typewriter_mode

return M
