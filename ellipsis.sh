pkg.install() {
  mkdir ~/.vim
  mkdir ~/.vim/swapfiles
  mkdir ~/.vim/undofiles
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  mkdir ~/.newsboat
  mkdir ~/scripts
  curl https://raw.githubusercontent.com/NonlinearFruit/english-words/master/words.txt > $ELLIPSIS_HOME/scripts/words.txt
}

pkg.link() {
  # Add all home links
  hooks.link

  # Add scipt links
  mkdir -p "$ELLIPSIS_HOME/scripts"
  for file in $PKG_PATH/scripts/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      fs.link_file $file "$ELLIPSIS_HOME/scripts/$filename"
    fi
  done

  # Add newsboat links
  mkdir -p "$ELLIPSIS_HOME/.newsboat"
  for file in $PKG_PATH/.newsboat/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      fs.link_file $file "$ELLIPSIS_HOME/.newsboat/$filename"
    fi
  done
}

pkg.unlink() {
  # Remove all home links
  hooks.unlink

  # Remove scipts
  for file in $PKG_PATH/scripts/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      rm "$ELLIPSIS_HOME/scripts/$filename"
    fi
  done
}
