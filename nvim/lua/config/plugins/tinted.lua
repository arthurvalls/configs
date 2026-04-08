return {
	"tinted-theming/tinted-nvim",
	lazy = false,
	enabled = false,
	priority = 1000,
	config = function()
		require("tinted-colorscheme").setup("base24-one-black", {
			supports = {
				tinty = true,
				tinted_shell = false,
			},
			highlights = {
				telescope = true,
				telescope_borders = false,
				indentblankline = true,
				notify = true,
				cmp = true,
				ts_rainbow = true,
				illuminate = true,
				lsp_semantic = true,
				mini_completion = true,
				dapui = true,
			},
		})
	end,
}
