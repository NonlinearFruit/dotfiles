curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust (https://www.rust-lang.org/tools/install)

# dotnet (https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu)
repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install dotnet-sdk-7.0
