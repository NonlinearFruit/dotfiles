local group = vim.api.nvim_create_augroup("python", { clear = true })

local function keymap(key, cmd, description)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = { "*.py" },
    callback = function()
      vim.keymap.set("n", "<leader>" .. key, "<cmd>" .. cmd .. "<cr>", { desc = description })
    end,
  })
end

if packer_plugins["vimux"] and packer_plugins["vimux"].loaded then
  local function vimuxkeymap(key, shellCommand, description)
    keymap(key, "VimuxRunCommand('" .. shellCommand .. "')", description)
  end

  vimuxkeymap("at", "pdm test", "[A]ll [T]ests")
  vimuxkeymap("bc", "pdm build", "[B]uild/[C]ompile")
  vimuxkeymap("er", "pdm run", "[E]xecute [R]un")
end
