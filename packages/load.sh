#!/bin/bash

# Update and upgrade
sudo apt update
sudo apt upgrade -y

# Install basic packages
sudo apt install -y wget curl

# Add PPAs
echo "Adding PPAs..."
while read ppa; do
    sudo add-apt-repository -y "$ppa"
done < ppa_list.txt
sudo apt update

# Install saved packages
echo "Installing saved packages..."
sudo dpkg --set-selections < installed_packages.txt
sudo apt-get dselect-upgrade -y

# Install Snap packages
echo "Installing Snap packages..."
while read snap; do
    sudo snap install "$snap"
done < snap_packages.txt

# Install Flatpak packages
echo "Installing Flatpak packages..."
while read flatpak; do
    flatpak install -y "$flatpak"
done < flatpak_packages.txt

# Install pip packages
echo "Installing pip packages..."
pip install -r pip_packages.txt

# Install global npm packages
echo "Installing global npm packages..."
xargs sudo npm install -g < npm_packages.txt

# Restore configuration files
echo "Restoring configuration files..."
cp -r configs/nvim ~/.config/nvim
cp configs/bashrc ~/.bashrc
# cp configs/zshrc ~/.zshrc
# cp configs/vimrc ~/.vimrc
# cp configs/gitconfig ~/.gitconfig

echo "All configurations restored successfully. Please restart your shell or source the appropriate configuration files."

