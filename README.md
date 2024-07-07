# qtcreator

move `.xml` file into 

	.config/QtProject/qtcreator/styles

# sublime

move `.tmTheme` into 

	.config/sublime-text/Packages

# gnome

export current themes:

	dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf

import themes from file:

	dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf

another option -> run the script

	./crimson_terminal.sh

# useful link

to customize and create new themes click [here](https://terminal.sexy/)