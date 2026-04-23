return {
	"jan-warchol/selenized",
	lazy = false,
	priority = 1000,
	config = function(plugin)
		vim.opt.rtp:append(plugin.dir .. "/editors/vim")
		vim.o.background = "light"
		vim.cmd.colorscheme("selenized")
	end,
}
