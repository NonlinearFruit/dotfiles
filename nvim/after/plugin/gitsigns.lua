local status_git_signs, gitsigns = pcall(require, 'gitsigns')
if not status_git_signs then
  return
end

gitsigns.setup({
  signcolumn = true,
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, key, cmd, opts)
      opts = opts or {}
      opts.buffer = buffer
      vim.keymap.set(mode, key, cmd, opts)
    end

    local function simple_map(mode, key, cmd, description)
      map(mode, key, cmd, { desc = description })
    end

    -- Navigation
    simple_map('n', ']c', gs.next_hunk, "[]] Jump to next [c]hange")
    simple_map('n', '[c', gs.prev_hunk, "[[] Jump to previous [c]hange")

    -- Actions
    simple_map({'n', 'v'}, '<leader>hs', gs.stage_hunk, "[h]unk [s]tage")
    simple_map({'n', 'v'}, '<leader>hr', gs.reset_hunk, "[h]unk [r]eset")
    simple_map('n', '<leader>hS', gs.stage_buffer, "[h]unk [S]tage buffer")
    simple_map('n', '<leader>hR', gs.reset_buffer, "[h]unk [R]eset buffer")
    simple_map('n', '<leader>hp', gs.preview_hunk, "[h]unk [p]review")
    --simple_map('n', '<leader>hu', gs.undo_stage_hunk)
    --simple_map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    --simple_map('n', '<leader>tb', gs.toggle_current_line_blame)
    --simple_map('n', '<leader>hd', gs.diffthis)
    --simple_map('n', '<leader>hD', function() gs.diffthis('~') end)
    --simple_map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    simple_map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', '[i]nner [h]unk')
  end
})