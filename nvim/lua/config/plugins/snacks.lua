return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		notifier = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		words = { enabled = true },
		gitbrowse = { enabled = true },
		zen = { enabled = true },
		scratch = { enabled = true },
		terminal = { enabled = true },
		dim = { enabled = false }, -- per-redraw focus dimming; off unless needed
		statuscolumn = { enabled = true },
		toggle = { enabled = true },
		lazygit = { enabled = true },
		profiler = { enabled = false }, -- debug-only; enable on demand to profile
		scope = { enabled = true },
	},
  -- stylua: ignore
  keys = {
    { "<leader>z",  function() Snacks.zen() end,              desc = "Toggle Zen Mode" },
    { "<leader>.",  function() Snacks.scratch() end,           desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end,    desc = "Select Scratch Buffer" },
    { "<leader>gg", function() Snacks.lazygit() end,           desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end,       desc = "Lazygit Log (cwd)" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end,  desc = "Lazygit Log (file)" },
    { "<leader>un", function() Snacks.notifier.hide() end,     desc = "Dismiss Notifications" },
    { "<c-/>",      function() Snacks.terminal() end,          desc = "Toggle Terminal" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
}
