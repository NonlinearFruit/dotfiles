pkg.install() {
  mkdir ~/.vim/swapfiles
  mkdir ~/.vim/undofiles
  curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -e "^[a-z]\+$" > $ELLIPSIS_HOME/scripts/words.txt
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
