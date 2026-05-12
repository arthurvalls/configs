return {
	"nvim-neotest/neotest",
	keys = {
		{ "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
		{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
		{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
		{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
		{ "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Open test output" },
	},
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rcasia/neotest-java",
	},
	config = function()
		require("neotest").setup({
			adapters = { require("neotest-java") },
		})
	end,
}
