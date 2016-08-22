#!/bin/bash

echo ""
echo "Archiving any existing configuration files..."

ARCHIVE_PATH=$HOME"/dotfiles/archive/"
DOTFILES_PATH=$HOME"/dotfiles/"
#DOT_FILES=(".bash_profile" ".bashrc" ".tmux.conf" ".vimrc")
DOT_FILES=(".test_me" ".test_me_too")

# create archive folder
mkdir -p ${ARCHIVE_PATH}

for FILENAME in "${DOT_FILES[@]}"
do
  FILEPATH="$HOME/$FILENAME"

  if [ -f "$FILEPATH" ]; then
    mv "$FILEPATH" "$ARCHIVE_PATH"
  fi 
done

echo "Creating symbolic links to dotfiles..."

for FILENAME in "${DOT_FILES[@]}"
do
  FILEPATH="$HOME/$FILENAME"
  SYMLINKPATH="$DOTFILES_PATH$FILENAME"
  ln -s "$SYMLINKPATH" "$FILEPATH"
done

echo "Done!"
