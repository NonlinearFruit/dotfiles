# dotnet <https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install>
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --version latest
rm ./dotnet-install.sh

# Check for out of date nugets and update them (https://github.com/dotnet-outdated/dotnet-outdated)
dotnet tool install --global dotnet-outdated-tool
