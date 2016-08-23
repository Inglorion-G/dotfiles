#!/bin/bash

echo ""

ARCHIVE_PATH=$HOME"/dotfiles/archive/"
DOTFILES_PATH=$HOME"/dotfiles/"
DOT_FILES=(".bash_profile" ".bashrc" ".tmux.conf" ".vimrc")
timestamp=$(date +%s)

echo "Archiving any existing configuration files and"
echo "creating symbolic links to dotfiles..."

# create an archive directory $HOME/dotfiles/archive
sudo mkdir -p ${ARCHIVE_PATH}

# back up and symlink .files from $HOME -> $HOME/dotfiles
for FILENAME in "${DOT_FILES[@]}"
do
  FILEPATH="$HOME/$FILENAME"

  if [ -f "$FILEPATH" ]; then
    mv "$FILEPATH" "$ARCHIVE_PATH/$FILENAME$timestamp"
  fi

  SYMLINKPATH="$DOTFILES_PATH$FILENAME"
  ln -s "$SYMLINKPATH" "$FILEPATH"
done

echo "Checking permissions for Homebrew..."

# check for homebrew path and correct permissions
HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    echo "Fixing permissions for Homebrew..."
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  echo "Creating required directories for Homebrew"
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

# check for homebrew and install if missing
if ! command -v brew >/dev/null; then
  echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    export PATH="/usr/local/bin:$PATH"
fi

brew update

brew install macvim --with-override-system-vim

echo "Making vim backup/swap directory..."

# backup dir for vim
if ! [ -d "$HOME/.vim_temp/" ]; then
  sudo mkdir $HOME/.vim_temp
fi

echo "Done!"
