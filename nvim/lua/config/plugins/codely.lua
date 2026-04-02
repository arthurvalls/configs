return {
	"codingpotions/codely-vim-theme",
	lazy = false,
	enabled = false,
	priority = 1000,
	background = "dark",
	config = function()
		vim.cmd.colorscheme("codely-theme")
	end,
}
