# === Aliases from Zsh shell ===




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
