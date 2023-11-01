# cabal (https://www.haskell.org/cabal/)
if command -v dnf > /dev/null; then
  sudo dnf install -y cabal-install
else
  sudo apt install -y cabal-install
fi
cabal update

# patat: cli slideshow (https://github.com/jaspervdj/patat?tab=readme-ov-file#from-source)
# Install pandoc & happy
cabal install patat
