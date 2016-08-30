#!/bin/bash

echo "Initializing development environment..."

ARCHIVE_PATH=$HOME"/dotfiles/archive/"
DOTFILES_PATH=$HOME"/dotfiles/"
DOT_FILES=(".bash_profile" ".bashrc" ".tmux.conf" ".vimrc")
timestamp=$(date +%s)

# create an archive directory $HOME/dotfiles/archive
echo "Archiving any existing configuration files and creating symbolic links to dotfiles..."
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

# check for homebrew path and correct permissions
echo "Checking permissions for Homebrew..."

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    echo "Fixing permissions for Homebrew..."
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  echo "Creating required directories for Homebrew..."
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

# update homebrew
brew update

# install macvim
if brew list | grep -Fq macvim; then
  echo "Macvim already installed!"
else
  brew install macvim --with-override-system-vim
fi

# install vim theme
if ! [ -e "$HOME/.vim/colors/SpacegrayEighties.vim" ]; then
  echo "Installing SpacegrayEighties vim theme..."
  mkdir -p $HOME/.vim/colors

  cd $HOME/.vim/colors && curl -O \
    'https://raw.githubusercontent.com/hhff/SpacegrayEighties.vim/master/colors/SpacegrayEighties.vim'
fi

# create backup and swap dir for vim
echo "Making vim backup/swap directory..."

if ! [ -d "$HOME/.vim_temp/" ]; then
  sudo mkdir $HOME/.vim_temp
fi

echo "Done!"
