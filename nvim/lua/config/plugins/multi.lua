return {
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			-- Define the keymaps for vim-visual-multi
			vim.g.VM_maps = {
				-- Map Ctrl+D to 'Find Under' (standard VS Code behavior)
				["Find Under"] = "<C-d>",
				["Find Subword Under"] = "<C-d>", -- Also map for visual mode

				-- Map Ctrl+C to 'Exit' (acts like Esc to leave multi-cursor mode)
				["Exit"] = "<C-c>",
			}
		end,
	},
}
