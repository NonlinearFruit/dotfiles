pkg.link() {
  # Add all home links
  hooks.link

  # Add scipt links
  mkdir -p "$ELLIPSIS_HOME/scripts"
  for file in $PKG_PATH/scripts/*; do
    filename=$(basename "$file")
    fs.link_file $file "$ELLIPSIS_HOME/scripts/$filename"
  done
}

pkg.unlink() {
  # Remove all home links
  hooks.unlink

  # Remove scipts
  for file in $PKG_PATH/scripts/*; do
    filename=$(basename "$file")
    rm "$ELLIPSIS_HOME/scripts/$filename"
  done
}
