return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Oil",
	keys = {
		{ "-", "<cmd>Oil --float<cr>", desc = "Open Parent Directory (Oil)" },
	},
	opts = {
		default_file_explorer = false,
		view_options = {
			show_hidden = true,
		},
		float = {
			padding = 2,
			max_width = 120,
			max_height = 40,
		},
	},
}
