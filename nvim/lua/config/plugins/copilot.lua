return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	opts = {
		suggestion = { enabled = false }, -- completions come through blink.cmp via blink-copilot
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
}
