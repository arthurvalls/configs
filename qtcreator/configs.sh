#!/bin/bash

# Function to check if root privileges are needed

# Copy .ttf files
for file in qtconfig/*.ttf; do
  # Check if file exists
  if [ -f "$file" ]; then
      # Copy with root privileges
      sudo cp -v "$file" /usr/share/fonts/
    fi
done

for file in qtconfig/*.otf; do
  # Check if file exists
  if [ -f "$file" ]; then
      # Copy with root privileges
      sudo cp -v "$file" /usr/share/fonts/
    fi
done

# Copy .xml files
for file in qtconfig/*.xml; do
  # Check if file exists
  if [ -f "$file" ]; then
    # Copy to user's Qt Creator styles directory
    cp -v "$file" ~/.config/QtProject/qtcreator/styles/
  fi
done

for file in qtconfig/*.css; do
  # Check if file exists
  if [ -f "$file" ]; then
    # Copy to user's Qt Creator styles directory
    cp -v "$file" ~/.config/QtProject/qtcreator/styles/
  fi
done

echo "Copy completed!"

