local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

return {
  send = function(opts, current_file)
    opts = opts or {}
    pickers
      .new(opts, {
        prompt_title = "nvim servers",
        finder = finders.new_oneshot_job({ "nvim-list-servers" }, {
          entry_maker = function(entry)
            local current_server = vim.api.nvim_get_vvar("servername")
            local server = vim.json.decode(entry)
            if current_server == server.nvim_server_name then
              return nil
            end
            return {
              value = server,
              display = server.tmux_window .. "." .. server.tmux_pane_index,
              ordinal = server.tmux_window .. "." .. server.tmux_pane_index,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local server = selection.value
            vim.fn.system("nvim --server " .. server.nvim_server_name .. " --remote-tab " .. current_file)
          end)
          return true
        end,
      })
      :find()
  end,
}
