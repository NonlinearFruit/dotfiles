#!/usr/bin/env sh

# Run this after cloning, then run `./gap.sh | sh` to link/cp out the configs

mkdir ~/.vim
mkdir ~/.vim/swapfiles
mkdir ~/.vim/undofiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir ~/scripts
curl https://raw.githubusercontent.com/NonlinearFruit/english-words/master/words.txt > $ELLIPSIS_HOME/scripts/words.txt
