return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "Avante", "codecompanion" },
	opts = {
		file_types = { "markdown", "Avante", "codecompanion" },
		heading = { sign = false },
		code = { sign = false, width = "block", min_width = 60 },
		completions = { lsp = { enabled = true } },
	},
}
