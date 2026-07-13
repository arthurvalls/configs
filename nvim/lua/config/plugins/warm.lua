return {
	{
		"warm",
		dir = vim.fn.stdpath("config") .. "/colors",
		name = "claude_warm",
		lazy = false, -- Make sure it loads on startup
		priority = 1000, -- Load this before other plugins to prevent weird flashing
		config = function()
			vim.cmd("colorscheme warm")
		end,
	},
}
