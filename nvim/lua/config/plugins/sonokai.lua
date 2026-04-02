return {
	"sainnhe/sonokai",
	lazy = false,
	enabled = false,
	priority = 1000,
	config = function()
		vim.g.sonokai_enable_italic = true
		vim.cmd.colorscheme("sonokai")
	end,
}
