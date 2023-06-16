local js = vim.api.nvim_create_augroup("JS", {clear = true})

local function keymap(key, cmd, description)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = js,
    pattern = { "*.js", "*.ts" },
    callback = function() vim.keymap.set("n", "<leader>"..key, "<cmd>"..cmd.."<cr>", { desc = description }) end
  })
end

if packer_plugins["vimux"] and packer_plugins["vimux"].loaded then
  local function vimuxkeymap(key, shellCommand, description)
    keymap(key, "VimuxRunCommand('"..shellCommand.."')", description)
  end

  vimuxkeymap("at", "npm test", "[A]ll [T]ests")
  vimuxkeymap("bc", "npm ci", "[B]uild/[C]ompile")
  vimuxkeymap("er", "npm run", "[E]xecute [R]un")
end
