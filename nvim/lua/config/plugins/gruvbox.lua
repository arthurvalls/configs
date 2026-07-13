return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			terminal_colors = false,
			transparent_mode = true,
		})
		vim.o.background = "light"
		vim.cmd.colorscheme("gruvbox")
	end,
}
