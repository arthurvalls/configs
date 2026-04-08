return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = "VeryLazy",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			always_show_bufferline = false,
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					highlight = "Directory",
					separator = true,
				},
			},
		},
	},
  -- stylua: ignore
  keys = {
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",        desc = "Toggle Pin" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close Non-Pinned" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",      desc = "Close Others" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>",       desc = "Close to Right" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",        desc = "Close to Left" },
    { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",        desc = "Prev Buffer" },
    { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",        desc = "Next Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end,      desc = "Close Buffer" },
  },
}
