if not packer_plugins["omnisharp-vim"] or not packer_plugins["omnisharp-vim"].loaded then
  return
end

-- HOW TO
-- 1. Install package with :PackerSync
-- 2. Install omnisharp server :OmniSharpInstall
-- 3. Manually start with :OmniSharpStartServer
--    - Should autostart when opening a .cs file

-- Error: The "ResolvePackageAssets" task failed unexpectedly
-- 1. Check `dotnet build` works
-- 2. Remove bin/obj `rm -rf */{bin,obj}`

-- Use the better faster newer server
vim.g.OmniSharp_server_stdio = 1

-- .Net 6, booya
vim.g.OmniSharp_server_use_net6 = 1
