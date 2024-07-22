#!/bin/bash

# Check if a commit message is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <commit_message>"
  exit 1
fi

# Run the copy.sh script
./copy.sh

# Display git differences
git diff

# Commit and push changes
git commit -am "$1"
git push
