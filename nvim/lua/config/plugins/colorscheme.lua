-- nerv theme is bundled locally at colors/nerv.lua (from wongmjane/nerv-theme)
return {
	"nerv-theme",
	virtual = true,
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("nerv")
	end,
}
