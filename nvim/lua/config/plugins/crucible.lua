return {
	"arthurvalls/crucible.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("crucible").setup({
			variant = "kintsugi", -- "crucible" | "bogfire" | "kintsugi"
			sync_ghostty = false, -- reload ghostty manually after changes
		})
		vim.cmd.colorscheme("crucible")
	end,
}
