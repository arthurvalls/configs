# config.fish — cozy fish defaults 🌱
# fish gives you autosuggestions (grey text — press → to accept) and
# highlights commands in colour as you type. This file adds a warm
# greeting, the starship prompt, and a few handy shortcuts.

# A gentle welcome instead of fish's default banner.
set -g fish_greeting
function fish_greeting
    set_color green
    echo "  welcome back 🌱  (type 'help' any time you're stuck)"
    set_color normal
end

# Locally-installed tools (like starship) live here.
if test -d "$HOME/.local/bin"
    fish_add_path "$HOME/.local/bin"
end

# The pretty prompt.
if type -q starship
    starship init fish | source
end

# --- Friendly shortcuts ---
alias ll  "ls -lh"       # list files, nicely
alias la  "ls -lha"      # ...including hidden ones
alias ..  "cd .."        # go up one folder
alias ... "cd ../.."     # go up two
alias cls "clear"        # clear the screen
