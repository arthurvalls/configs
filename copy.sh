#!/bin/bash

# Copy Neovim configuration files
cp ~/.config/nvim/* /home/arthurvalls/configs/nvim/

# Copy Alacritty configuration files
cp -r ~/.config/alacritty/* /home/arthurvalls/configs/alacritty/

# Copy tmux configuration file to Alacritty directory
cp ~/.tmux.conf /home/arthurvalls/configs/alacritty/.tmux.conf

# Copy Zsh configuration file
cp ~/.config/ezsh/ezshrc.zsh /home/arthurvalls/configs/zsh/

# Copy qtcreator configurations
cp -r ~/workspace/scripts/* /home/arthurvalls/configs/qtcreator/

cp -r /usr/share/fonts/* ./fonts/

echo "Configuration files have been copied successfully."
