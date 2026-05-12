return {
	-- nvim-dap itself loads via keys in kickstart/plugins/debug.lua.
	-- DAP UI — pulled in on demand by neotest or debug keymaps.
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
		end,
	},
	-- DAP Virtual Text — only matters once a session is running.
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	-- vim-test only matters when actually running a test.
	{
		"janko/vim-test",
		cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
	},
}
