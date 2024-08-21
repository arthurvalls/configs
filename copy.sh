#!/bin/bash

# Copy Neovim configuration files
cp ~/.config/nvim/* /home/arthur/configs/nvim/

# Copy Alacritty configuration files
cp -r ~/.config/alacritty/* /home/arthur/configs/alacritty/

# Copy tmux configuration file to Alacritty directory
cp ~/.tmux.conf /home/arthur/configs/alacritty/.tmux.conf

# Copy Zsh configuration file
cp ~/.config/ezsh/ezshrc.zsh /home/arthur/configs/zsh/

# Copy qtcreator configurations
cp -r ~/workspace/scripts/* /home/arthur/configs/qtcreator/

echo "Configuration files have been copied successfully."
