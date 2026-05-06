-- Nightfox plugin spec. Theme-sync logic lives in lua/config/terminal-sync.lua
-- (always loaded from init.lua, independent of which colorscheme plugin is active).

return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nightfox").setup({
			options = {
				terminal_colors = true,
				styles = {
					comments = "italic",
					keywords = "bold",
				},
			},
		})
	end,
}
