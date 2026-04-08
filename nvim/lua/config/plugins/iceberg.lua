return {
	{
		"cocopon/iceberg.vim",
		lazy = false,
	enabled = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme retrobox]])
			-- vim.cmd([[colorscheme iceberg]])

			-- Use a helper function to keep existing colors but add italics
			local function italicize(group)
				-- Get the current highlight attributes for the group
				local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
				-- Re-set the group with italics added
				hl.italic = true
				vim.api.nvim_set_hl(0, group, hl)
			end

			-- List all groups you want to italicize
			local groups = {
				"Statement",
				"Keyword",
				"Conditional",
				"Repeat",
				"Structure",
				"Typedef",
				"StorageClass",
				"@keyword.storage",
				"@type.qualifier",
			}

			for _, group in ipairs(groups) do
				italicize(group)
			end
		end,
	},
}
