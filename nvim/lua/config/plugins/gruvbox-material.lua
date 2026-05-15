-- Gruvbox Material (sainnhe). Dark variant.
-- Kitty palette synced via lua/config/terminal-sync.lua → ~/.config/kitty/gruvbox-material.conf.

return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_background = "hard" -- "hard" | "medium" | "soft"
		vim.g.gruvbox_material_foreground = "material" -- "material" | "mix" | "original"
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_better_performance = 1
		vim.o.background = "dark"
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
