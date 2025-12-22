return {
	"RRethy/base16-nvim",
	telescope = true,
	indentblankline = true,
	notify = true,
	ts_rainbow = true,
	cmp = true,
	illuminate = true,
	dapui = true,
	config = function()
		vim.cmd("colorscheme base16-selenized-light")
	end,
}
