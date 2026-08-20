local function configure()
  local db = require("dashboard")
  local catechism_file = os.getenv("HOME") .. "/scripts/westminster_shorter_catechism.json"
  local file_contents = table.concat(vim.fn.readfile(catechism_file), "\n")
  local wsc = vim.json.decode(file_contents)
  math.randomseed(os.time())
  local number = math.random(1, 107)
  local question = wsc.Data[number].Question
  local answer = wsc.Data[number].Answer
  local header = { -- http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Neovim
    "                                                  ",
    "                                                  ",
    "                                                  ",
    "                                                  ",
    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    "                                                  ",
    "                                                  ",
  }
  local function wrap_text(text, width)
    local lines = {}
    local line = ""

    for word in text:gmatch("%S+") do
      local candidate = line == "" and word or line .. " " .. word
      if #candidate <= width then
        line = candidate
      else
        if line ~= "" then
          table.insert(lines, line)
        end
        line = word
      end
    end

    if line ~= "" then
      table.insert(lines, line)
    end

    return lines
  end
  local footer = {
    "                                                                ",
    "_   _             _ _                       _____           _ _",
    " | \\ | | ___  _ __ | (_)_ __   ___  __ _ _ __|  ___| __ _   _(_) |_",
    "  |  \\| |/ _ \\| '_ \\| | | '_ \\ / _ \\/ _` | '__| |_ | '__| | | | | __|",
    " | |\\  | (_) | | | | | | | | |  __/ (_| | |  |  _|| |  | |_| | | |_",
    "  |_| \\_|\\___/|_| |_|_|_|_| |_|\\___|\\__,_|_|  |_|  |_|   \\__,_|_|\\__|",
    "                                                                ",
    "                                                                ",
  }
  for _, line in ipairs(wrap_text("Q" .. number .. " " .. question, 66)) do
    table.insert(footer, line)
  end
  table.insert(footer, "                                                                ")
  for _, line in ipairs(wrap_text(answer, 66)) do
    table.insert(footer, line)
  end

  db.setup({
    theme = "doom",
    config = {
      header = header,
      center = {
        {
          icon = " ",
          desc = "Empty buffer",
          key = "n",
          key_hl = "LineNr",
          action = "enew",
        },
        {
          icon = " ",
          desc = "Find Files",
          key = "f",
          key_hl = "LineNr",
          action = "Telescope find_files",
        },
        {
          icon = " ",
          desc = "Browse File Tree",
          key = "-",
          key_hl = "LineNr",
          action = "Oil",
        },
        {
          icon = "󰒲 ",
          desc = "Lazy",
          key = "l",
          key_hl = "LineNr",
          action = "Lazy",
        },
        {
          icon = " ",
          desc = "Update Mason Registries",
          key = "m",
          key_hl = "LineNr",
          action = "MasonUpdate",
        },
        {
          icon = " ",
          desc = "Dotfiles",
          key = ".",
          key_hl = "LineNr",
          action = "Telescope find_files cwd=~/projects/dotfiles",
        },
        {
          icon = " ",
          desc = "Catechism",
          key = "c",
          key_hl = "LineNr",
          action = "lua vim.ui.open('https://www.youtube.com/watch?v=+&list=PLDTpYNNVdp--3o7UpYj0EtfYFshewR2R3&index="
            .. (number - 1)
            .. "')",
        },
        {
          icon = "󰩈 ",
          desc = "Quit",
          key = "q",
          key_hl = "LineNr",
          action = "qa",
        },
      },
      footer = footer,
    },
  })
end

return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  config = configure,
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      commit = "d06a97319ff761388f3fb4cbdcdc3ec69cbfba21", -- Wezterm's bundled nerd font is old, can't use latest without missing glyphs
    },
  },
}
