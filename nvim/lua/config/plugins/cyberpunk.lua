return {
	{
		"thedenisnikulin/vim-cyberpunk",
		lazy = true,
	enabled = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme cyberpunk]])
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1a2e" })
		end,
	},
}
