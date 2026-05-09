return {
	"gerardbm/vim-atomic",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.atomic_mode = 11 -- Night MC
		vim.o.background = "dark"
		vim.cmd.colorscheme("atomic")
	end,
}
