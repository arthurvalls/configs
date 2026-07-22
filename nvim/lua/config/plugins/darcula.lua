return {
	"xiantang/darcula-dark.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		-- Setup must be called before loading the colorscheme
		require("darcula").setup({
			override = function(c)
				return {
					background = "#0a0a0a",
					dark = "#0a0a0a", -- Set both so the UI background matches uniformly
				}
			end,
		})

		vim.cmd.colorscheme("darcula-dark")
	end,
}
