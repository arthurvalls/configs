function md --description 'Render a Markdown file in the terminal with glow'
    set -l cols (tput cols 2>/dev/null)
    test -n "$cols"; or set cols 120
    glow --pager --width (math "$cols - 2") $argv
end
