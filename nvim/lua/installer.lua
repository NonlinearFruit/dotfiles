local ready = false
local queued = {}

local function install(packages)
  local registry = require("mason-registry")

  for _, pkg in ipairs(packages) do
    local name = pkg:gsub("@.*$", "")
    if not registry.is_installed(name) then
      registry.get_package(name):install()
    end
  end
end

local function install_if_missing(packages)
  if not ready then
    vim.list_extend(queued, packages)
    return
  end

  install(packages)
end

local function mark_mason_ready()
  ready = true
  install(queued)
  queued = {}
end

return {
  install_if_missing = install_if_missing,
  mark_mason_ready = mark_mason_ready,
}
