local rust = vim.api.nvim_create_augroup("Rust", { clear = true })

local function keymap(key, cmd, description)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = rust,
    pattern = { "*.rs" },
    callback = function()
      vim.keymap.set("n", "<leader>" .. key, "<cmd>" .. cmd .. "<cr>", { desc = description })
    end,
  })
end

if packer_plugins["vimux"] and packer_plugins["vimux"].loaded then
  local function vimuxkeymap(key, shellCommand, description)
    keymap(key, "VimuxRunCommand('" .. shellCommand .. "')", description)
  end

  vimuxkeymap("at", "cargo test", "[A]ll [T]ests")
  vimuxkeymap("bc", "cargo build", "[B]uild/[C]ompile")
  vimuxkeymap("er", "cargo run", "[E]xecute [R]un")
end
