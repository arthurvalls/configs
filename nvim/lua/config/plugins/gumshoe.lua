return {
	"arthurvalls/gumshoe.nvim",
	dir = vim.fn.expand("~/personal/gumshoe.nvim"),
	dev = true,
	lazy = false,
	priority = 1000,
	config = function()
		require("gumshoe").setup({})
		vim.cmd.colorscheme("gumshoe")
	end,
}
