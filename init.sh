#!/usr/bin/env sh

mkdir ~/.vim
mkdir ~/.vim/swapfiles
mkdir ~/.vim/undofiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir ~/scripts
curl https://raw.githubusercontent.com/NonlinearFruit/english-words/master/words.txt > $ELLIPSIS_HOME/scripts/words.txt
