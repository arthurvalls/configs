-- vscode.nvim — https://github.com/Mofiqul/vscode.nvim
return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("vscode").setup({
			style = "dark",
			transparent = false,
			italic_comments = true,
			underline_links = true,
			disable_nvimtree_bg = true,
			terminal_colors = true,
		})
		vim.cmd.colorscheme("vscode")
	end,
}
