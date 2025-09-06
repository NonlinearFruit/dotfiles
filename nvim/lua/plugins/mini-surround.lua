-- TODO: This works but better would be:
-- * Only visual bindings
-- * Binding is:
--     * sa<character>: adds <character> around the selection
--     * sr<character>: replaces whatever is currently wrapping the selection with <character>
--     * sd<character>: deletes <character> around the selection
-- * Visual mode: Look at start and end of selection
-- * Visual block mode: Look at start and end of each line selection
-- * Visual line mode: Look at start and end of each line? Or of the whole selection?
local function configure()
  require("mini.surround").setup({})
  vim.keymap.del("n", "sn")
  vim.keymap.del("n", "sfl")
  vim.keymap.del("n", "sFl")
  vim.keymap.del("n", "shl")
  vim.keymap.del("n", "srl")
  vim.keymap.del("n", "sa")
  vim.keymap.del("n", "sdl")
  vim.keymap.del("n", "sfn")
  vim.keymap.del("n", "sFn")
  vim.keymap.del("n", "shn")
  vim.keymap.del("n", "srn")
  vim.keymap.del("n", "sdn")
  vim.keymap.del("n", "sf")
  vim.keymap.del("n", "sF")
  vim.keymap.del("n", "sh")
  vim.keymap.del("n", "sr")
  vim.keymap.del("n", "sd")
end

return {
  "echasnovski/mini.surround",
  config = configure,
}
