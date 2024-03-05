# Install a fixed version of golang: https://go.dev/doc/install
VERSION='1.21.6'
FILE="go$VERSION.linux-amd64.tar.gz"
curl "https://dl.google.com/go/$FILE" -o "$FILE"
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "$FILE"
rm "$FILE"

# usql - universal sql cli
# go install -tags most github.com/xo/usql@latest

# glab - gitlab cli
# go install gitlab.com/gitlab-org/cli/cmd/glab@main

# packwiz - Minecraft modpack manager
# go install github.com/packwiz/packwiz@latest
