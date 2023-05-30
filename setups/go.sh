# Install a fixed version of golang: https://go.dev/doc/install
FILE='go1.20.4.linux-amd64.tar.gz'
curl https://go.dev/dl/$FILE
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf $FILE
