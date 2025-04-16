#!/bin/bash

# Copy Neovim configuration files
cp -r ~/.config/nvim/* /home/arthurvalls/configs/nvim/

# Copy Alacritty configuration files
cp -r ~/.config/alacritty/* /home/arthurvalls/configs/alacritty/

# Copy tmux configuration file to Alacritty directory
cp -r ~/.tmux.conf /home/arthurvalls/configs/alacritty/.tmux.conf

# Copy Zsh configuration file
cp -r ~/.config/ezsh/ezshrc.zsh /home/arthurvalls/configs/zsh/

# Copy kitty conf
#
cp -r ~/.config/kitty/kitty.conf /home/arthurvalls/configs/kitty


echo "Configuration files have been copied successfully."
