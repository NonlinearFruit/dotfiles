local function install_if_missing(things_to_install)
  for _, pkg in ipairs(things_to_install) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
end

return {
  install_if_missing = install_if_missing,
}
