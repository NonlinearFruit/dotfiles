if not packer_plugins["omnisharp-vim"] or not packer_plugins["omnisharp-vim"].loaded then
  return
end

-- HOW TO 
-- 1. Install package with :PackerSync
-- 2. Install omnisharp server :OmniSharpInstall
-- 3. Manually start with :OmniSharpStartServer
--    - Should autostart when opening a .cs file

-- Use the better faster newer server
vim.g.OmniSharp_server_stdio = 1

-- .Net 6, booya
vim.g.OmniSharp_server_use_net6 = 1

if vim.fn.has("wsl") then
  -- Use WSL
  vim.g.OmniSharp_translate_cygwin_wsl = 1
  -- Explicit server path
  vim.g.OmniSharp_server_path = '/mnt/c/Users/'..vim.fn.expand("$USER")..'/AppData/Local/omnisharp-vim/omnisharp-rosly/OmniSharp.exe'
end
