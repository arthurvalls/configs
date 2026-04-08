return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			globalstatus = true,
			disabled_filetypes = { statusline = { "dashboard" } },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {
				{ "diagnostics" },
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{ "filename", path = 1 },
			},
			lualine_x = {
				{
					"diff",
					symbols = { added = " ", modified = " ", removed = " " },
				},
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		extensions = { "neo-tree", "lazy", "trouble", "toggleterm" },
	},
}
