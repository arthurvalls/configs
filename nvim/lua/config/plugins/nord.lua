return {
	"shaunsingh/nord.nvim",
	lazy = false, -- We want this to load immediately for the colorscheme
	priority = 1000, -- Colorschemes should load first
	config = function()
		-- Optional: Set configuration variables before loading
		vim.g.nord_contrast = true
		vim.g.nord_borders = true
		vim.g.nord_disable_background = true
		vim.g.nord_italic = true
		vim.g.nord_uniform_diff_background = true
		vim.g.nord_bold = true

		-- Load the colorscheme
		require("nord").set()
	end,
}
