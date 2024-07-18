#!/bin/bash

# Save the list of installed packages
echo "Saving list of installed packages..."
dpkg --get-selections > installed_packages.txt

# Save list of PPAs (for Ubuntu/Debian-based systems)
echo "Saving list of PPAs..."
grep -hr ^deb /etc/apt/sources.list* > ppa_list.txt

# Save list of installed Snap packages
echo "Saving list of installed Snap packages..."
snap list > snap_packages.txt

# Save list of installed Flatpak packages
echo "Saving list of installed Flatpak packages..."
flatpak list --columns=application > flatpak_packages.txt

# Save pip packages
echo "Saving list of pip packages..."
pip freeze > pip_packages.txt

# Save global npm packages
echo "Saving list of global npm packages..."
npm list -g --depth=0 > npm_packages.txt

# Save configuration files
echo "Copying configuration files..."
mkdir -p configs
cp -r ~/.config/nvim configs/nvim
cp ~/.bashrc configs/bashrc
cp ~/.zshrc configs/zshrc
cp ~/.vimrc configs/vimrc
cp ~/.gitconfig configs/gitconfig

echo "All configurations saved successfully."

