return {
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			require("ayu").setup({
				mirage = true,
				terminal = true,
				overrides = {},
			})
			vim.cmd.colorscheme("ayu-dark")
		end,
	},
}
