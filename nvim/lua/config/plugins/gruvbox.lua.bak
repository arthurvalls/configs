-- gruvbox (ellisonleao/gruvbox.nvim), hard contrast, vantablack-like background.
--
-- Hard contrast makes bg0 = dark0_hard, and Normal.bg = bg0, so overriding
-- dark0_hard pushes the editor background to #0a0a0a while every gruvbox accent
-- and UI grey stays authentic.
--
-- terminal_colors = false on purpose: nvim then does NOT export terminal_color_*,
-- so terminal-sync.lua keeps the standard gruvbox ANSI baked into
-- ~/.config/kitty/gruvbox.conf (color0 = #282828, visible on vantablack) instead
-- of collapsing ANSI black onto the background. terminal-sync still overlays the
-- live Normal bg/fg + cursor + selection, so kitty mirrors the editor exactly.
-- Kitty palette is resolved by the filename fallback (~/.config/kitty/gruvbox.conf).

return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			terminal_colors = false,
			palette_overrides = {
				dark0_hard = "#0a0a0a", -- vantablack-like editor background
			},
		})
		vim.o.background = "dark"
		vim.cmd.colorscheme("gruvbox")
	end,
}
