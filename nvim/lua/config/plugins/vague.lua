-- vague (vague-theme/vague.nvim). Cool, dark, low-contrast — pastel yet washed out.
-- Kitty palette synced via lua/config/terminal-sync.lua → ~/.config/kitty/vague.conf
-- (resolved by the filename fallback; no entry needed in the sources map).

return {
	"vague-theme/vague.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("vague").setup({
			transparent = false,
		})
		vim.o.background = "dark"
		vim.cmd.colorscheme("vague")
	end,
}
