local function configure()
  local db = require("dashboard")
  local json = require("json")
  local io = require("io")

  local function read_file(path)
    local file = io.open(path, "r") -- r read mode and b binary mode
    if not file then
      return nil
    end
    local content = file:read("*a") -- *a or *all reads the whole file
    file:close()
    return content
  end
  local file_contents = read_file(os.getenv("HOME") .. "/scripts/westminster_shorter_catechism.json")
  local wsc = json.decode(file_contents)
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
  local footer = {
    "                                                                ",
    "_   _             _ _                       _____           _ _",
    " | \\ | | ___  _ __ | (_)_ __   ___  __ _ _ __|  ___| __ _   _(_) |_",
    "  |  \\| |/ _ \\| '_ \\| | | '_ \\ / _ \\/ _` | '__| |_ | '__| | | | | __|",
    " | |\\  | (_) | | | | | | | | |  __/ (_| | |  |  _|| |  | |_| | | |_",
    "  |_| \\_|\\___/|_| |_|_|_|_| |_|\\___|\\__,_|_|  |_|  |_|   \\__,_|_|\\__|",
    "                                                                ",
    "                                                                ",
    "Q" .. number .. " " .. question,
    "                                                                ",
  }
  local length = string.len(answer)
  local index = 1
  local increment = 66
  while length >= index + increment do
    table.insert(footer, string.sub(answer, index, index + increment - 1))
    index = index + increment
  end
  if length > index then
    table.insert(footer, string.sub(answer, index, length))
  end

  db.setup({
    theme = "doom",
    config = {
      header = header,
      center = {
        {
          icon = " ",
          desc = "Find Files",
          key = "f",
          key_hl = "LineNr",
          action = "Telescope find_files",
        },
        {
          icon = " ",
          desc = "Browser File Tree",
          key = "b",
          key_hl = "LineNr",
          action = "Oil",
        },
        {
          icon = "󰓦 ",
          desc = "Update Packages",
          key = "u",
          key_hl = "LineNr",
          action = "PackerSync",
        },
        {
          icon = " ",
          desc = "Update Mason Stuff",
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
  "glepnir/dashboard-nvim",
  config = configure,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
