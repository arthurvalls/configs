#!/bin/bash

# Copy Neovim configuration files
cp -r ~/.config/nvim/* /home/arthur/configs/nvim/

# Copy Alacritty configuration files
cp -r ~/.config/alacritty/* /home/arthur/configs/alacritty/

# Copy tmux configuration file to Alacritty directory
cp -r ~/.tmux.conf /home/arthur/configs/alacritty/.tmux.conf

# Copy Zsh configuration file
cp -r ~/.config/ezsh/ezshrc.zsh /home/arthur/configs/zsh/

# Copy kitty conf
cp -r ~/.config/kitty/* /home/arthur/configs/kitty

# Copy fish
cp -r ~/.config/fish/* /home/arthur/configs/fish/

cp -r ~/.config/git/* /home/arthur/configs/git/


echo "Configuration files have been copied successfully."
