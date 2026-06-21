-- Lualine statusline. The theme follows the active colorscheme: each standalone
-- scheme ships a matching lualine table (config/vanta-lualine, config/yorha-lualine).
-- A ColorScheme autocmd re-runs setup so the statusline swaps live with the theme.
local function theme_for(name)
	if name == "yorha" then
		return require("config.yorha-lualine")
	end
	return require("config.vanta-lualine")
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local opts = {
			options = {
				theme = theme_for(vim.g.colors_name),
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{ "diagnostics" },
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "neo-tree", "lazy", "trouble", "toggleterm" },
		}
		require("lualine").setup(opts)

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("LualineThemeSync", { clear = true }),
			callback = function(args)
				opts.options.theme = theme_for(args.match)
				require("lualine").setup(opts)
			end,
		})
	end,
}
