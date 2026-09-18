sudo dnf install -y dos2unix
winuser=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
winhome="/mnt/c/Users/${winuser}"
ln -sfn "$winhome" "$HOME/winhome"
