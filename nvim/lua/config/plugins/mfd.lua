return {
	{
		"kungfusheep/mfd.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("mfd").setup({
				accessibility_contrast = 4,
				no_italic = false,
			})

			vim.cmd.colorscheme("mfd-amber")

			vim.opt.guicursor = {
				"n:block-CursorNormal",
				"v:block-CursorVisual",
				"i-ci-ve:ver25-CursorInsert",
				"r-cr:hor20-CursorReplace",
				"c:block-CursorCommand",
				"o:hor50",
				"a:blinkwait700-blinkoff400-blinkon250",
				"sm:block-blinkwait175-blinkoff150-blinkon175",
			}

			require("mfd").enable_cursor_sync()
		end,
	},
}
