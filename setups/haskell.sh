# cabal (https://www.haskell.org/cabal/)
if command -v dnf > /dev/null; then
  sudo dnf install -y cabal-install
else
  sudo apt install -y cabal-install
fi

