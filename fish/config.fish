# === Aliases from Zsh shell ===

# Start the SSH agent if it's not already running
# if not set -q SSH_AUTH_SOCK or not ssh-add -l > /dev/null
#     ssh-agent -c | source
# end
#
# # Add your SSH key (replace ~/.ssh/id_ed25519 with your key path if different)
# # Only add the key if it's not already listed by ssh-add -l
# if not ssh-add -l | string match -q "*$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')*"
#     ssh-add ~/.ssh/id_ed25519
#     ssh-add ~/.ssh/github
# end

starship init fish | source

# Quickly show external IP address
alias myip 'wget -qO- https://wtfismyip.com/text'

# Show all except . .. , sort by recent, / at the end of folders
alias l 'ls -lAhrtF'

# This alias for empty is better as a function in ~/.config/fish/functions/empty.fish
# alias empty='empty_file() { cat /dev/null > "$1"; }; empty_file'

# List directories only
alias lsdd 'ls -d */'

# Alias for nvim
alias v 'nvim'

# Alias for lazygit
alias lz 'lazygit'

# Alias for eza
alias ez 'eza'

# Note: The 'empty' alias from your Zsh config is more complex and is better
# implemented as a Fish function. For a truly simple config with *only* aliases,
# I've commented it out here. If you want to include it, you should define it
# as a function in ~/.config/fish/functions/empty.fish:

# function empty
#     cat /dev/null > "$argv[1]"
# end

alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'




