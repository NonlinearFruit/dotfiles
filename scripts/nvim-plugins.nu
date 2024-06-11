'
local plugins = {}
local installed_plugins = require("lazy").plugins()
for _, plugin in ipairs(installed_plugins) do
  local handle = plugin[1]
  local name = plugin.name or handle
  local url = plugin.url

  if url and url:find("https://github.com") then
    local name_parts = vim.split(handle, "/")
    if #name_parts == 2 then
      local author = name_parts[1]

      table.insert(plugins, {
          name = name,
          handle = handle,
          url = url,
          author = author,
          })
    end
  end
end
print(vim.json.encode(plugins))
'
| do {
  ^nvim -u ~/.config/nvim/init.lua -l /dev/stdin
}
| complete
| get stderr
| from json
| where author != local
