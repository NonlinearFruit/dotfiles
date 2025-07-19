curl -L https://github.com/nushell/nushell/releases/download/0.105.1/nu-0.105.1-x86_64-unknown-linux-gnu.tar.gz -o nushell-compressed.tar.gz
tar xf nushell-compressed.tar.gz --directory=.
rm nushell-compressed.tar.gz
sudo mv nu-0.105.1-x86_64-unknown-linux-gnu/nu /usr/local/bin
rm -rf nu-0.105.1-x86_64-unknown-linux-gnu
