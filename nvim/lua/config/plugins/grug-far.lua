return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar", "GrugFarWithin" },
	keys = {
		{ "<leader>sr", function() require("grug-far").open() end, desc = "[S]earch and [R]eplace (project)" },
		{ "<leader>sR", function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end, desc = "[S]earch and [R]eplace (file)" },
		{ "<leader>sr", function() require("grug-far").with_visual_selection() end, mode = "v", desc = "[S]earch and [R]eplace (selection)" },
	},
	opts = {
		headerMaxWidth = 80,
	},
}
