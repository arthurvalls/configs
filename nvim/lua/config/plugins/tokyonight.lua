-- tokyonight (folke/tokyonight.nvim). Darkest variant: "night".
-- Kitty palette synced via lua/config/terminal-sync.lua → ~/.config/kitty/tokyonight-night.conf
-- (resolved by filename fallback, no entry in the sources map).

return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night", -- "storm" | "moon" | "night" (darkest) | "day"
		light_style = "day",
		transparent = false,
		terminal_colors = true,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			sidebars = "dark",
			floats = "dark",
		},
		dim_inactive = false,
		lualine_bold = false,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.o.background = "dark"
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
