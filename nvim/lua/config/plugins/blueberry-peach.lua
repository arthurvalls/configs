return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	enabled = false,
	opts = { flavour = "frappe", transparent_background = true },
	config = function(_, opts)
		local bp = require("blueberry_peach_dark")
		opts = vim.tbl_deep_extend("force", opts, bp.get_overrides("frappe"))
		require("catppuccin").setup(opts)
		vim.cmd([[colorscheme catppuccin]])
	end,
}
