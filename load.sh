#!/bin/bash

# Define source and destination directories
NvimSrc="/home/arthur/configs/nvim"
AlacrittySrc="/home/arthur/configs/alacritty"
TmuxSrc="/home/arthur/configs/alacritty/.tmux.conf"
ZshSrc="/home/arthur/configs/zsh/ezshrc.zsh"
FishSrc="/home/arthurvalls/configs/fish"
GitSrc="/home/arthurvalls/configs/git"

NvimDest="$HOME/.config/nvim"
AlacrittyDest="$HOME/.config/alacritty"
TmuxDest="$HOME/.tmux.conf"
ZshDest="$HOME/.config/ezsh"
FishDest="$HOME/.config/fish"
GitDest="$HOME/.config/git"
# Create destination directories if they do not exist

mkdir -p "$NvimDest"
mkdir -p "$AlacrittyDest"
mkdir -p "$ZshDest"
mkdir -p "$FishDest"
mkdir -p "$GitDest"


# Copy Neovim configuration files
if [ -d "$NvimSrc" ]; then
    cp "$NvimSrc"/* "$NvimDest/"
else
    echo "Neovim source directory does not exist: $NvimSrc"
fi

# Copy Alacritty configuration files
if [ -d "$AlacrittySrc" ]; then
    cp -r "$AlacrittySrc"/* "$AlacrittyDest/"
else
    echo "Alacritty source directory does not exist: $AlacrittySrc"
fi

# Copy tmux configuration file
if [ -f "$TmuxSrc" ]; then
    cp "$TmuxSrc" "$TmuxDest"
else
    echo "tmux configuration file does not exist: $TmuxSrc"
fi

# Copy Zsh configuration file
if [ -f "$ZshSrc" ]; then
    cp "$ZshSrc" "$ZshDest/"
else
    echo "Zsh configuration file does not exist: $ZshSrc"
fi

# Copy Zsh configuration file
if [ -f "$FishSrc" ]; then
    cp "$FishSrc" "$FishDest/"
else
    echo "Zsh configuration file does not exist: $FishSrc"
fi


# Copy Zsh configuration file
if [ -f "$GitSrc" ]; then
    cp "$GitSrc" "$GitDest/"
else
    echo "Zsh configuration file does not exist: $GitDest"
fi




cp -r ./fonts /usr/share/fonts/

sudo fc-cache -f -v


echo "Configuration files have been copied successfully."
