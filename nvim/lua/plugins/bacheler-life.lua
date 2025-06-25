local function configure()
  local function map(mode, key, cmd, description)
    vim.keymap.set(mode, key, cmd, { desc = description })
  end

  -- Remove obnoxious bindings
  map({ "n", "i" }, "<f1>", "<nop>", "This does nothing: Too close to Esc")

  -- Remove newbie crutches!
  map({ "n", "i", "v", "c" }, "<bs>", "<nop>", "This does nothing: Edit in normal mode")
  map({ "n", "i", "v", "c" }, "<del>", "<nop>", "This does nothing: Edit in normal mode")
  map({ "n", "i", "v", "c" }, "<down>", "<nop>", "This does nothing: Move in normal mode")
  map({ "n", "i", "v", "c" }, "<left>", "<nop>", "This does nothing: Move in normal mode")
  map({ "n", "i", "v", "c" }, "<right>", "<nop>", "This does nothing: Move in normal mode")
  map({ "n", "i", "v", "c" }, "<up>", "<nop>", "This does nothing: Move in normal mode")
end

return {
  "local/bacheler-life",
  cond = function()
    return os.execute("is lonely") == 0
  end,
  config = configure,
  virtual = true,
}
