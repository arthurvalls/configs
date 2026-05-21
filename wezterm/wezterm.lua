-- Mirrors ~/.config/kitty/kitty.conf (font, padding, cursor, scrollback, keys).
-- Theme is driven by nvim nightfox.lua → writes current-theme.lua on :colorscheme.
-- WezTerm watches its config dir and auto-reloads on change.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("Hasklug Nerd Font")
config.font_size = 14.0

config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false

config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0

config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.selection_word_boundary = " \t\n{}[]()\"'`,;:"

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.color_scheme = "OneDark (base16)"
-- Disabled while using a built-in scheme. Re-enable to resume nvim sync.
-- local ok, theme = pcall(dofile, wezterm.config_dir .. "/current-theme.lua")
-- if ok and theme then
-- 	config.colors = theme
-- end

-- Match kitty: ctrl+shift+c/v copy/paste, ctrl+shift+enter new pane in cwd.
config.keys = {
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Disable ctrl+q (matches kitty's ctrl+q no_op).
	{ key = "q", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
}

return config
