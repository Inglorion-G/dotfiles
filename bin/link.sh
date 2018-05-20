#!/bin/bash

DIR=`dirname $(cd $(dirname $0) && pwd -P)`
TARGET_DIR="$HOME"

# symlink top-level dotfiles to $HOME
DOTFILES=$DIR/home/.[a-z]*

for file in $DOTFILES; do
  target_file="$TARGET_DIR/`basename $file`"
  source_file=$file
  ln -s $source_file $target_file
done

# symlink directories and files in ./config to $HOME/.config
CONFIG_FILES=$DIR/.config/*
mkdir -p "$TARGET_DIR/.config"

for file in $CONFIG_FILES; do
  target_file="$TARGET_DIR/.config/`basename $file`"
  source_file=$file
  ln -s $source_file $target_file
done
