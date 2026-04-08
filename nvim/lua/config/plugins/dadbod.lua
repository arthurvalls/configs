return {
	-- Database interface for Neovim
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Load .env file from nvim config directory
		local env_file = vim.fn.stdpath("config") .. "/.env"
		if vim.fn.filereadable(env_file) == 1 then
			for line in io.lines(env_file) do
				-- Skip comments and empty lines
				if not line:match("^%s*#") and not line:match("^%s*$") then
					-- Parse DB_UI_* variables
					local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
					if key and value and key:match("^DB_UI_") then
						-- Remove quotes if present
						value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
						-- Set as environment variable
						vim.fn.setenv(key, value)
					end
				end
			end
		end

		-- Use nerd fonts for icons
		vim.g.db_ui_use_nerd_fonts = 1

		-- Drawer width
		vim.g.db_ui_winwidth = 40

		-- Save location for queries and connections
		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

		-- Auto-execute table helpers
		vim.g.db_ui_auto_execute_table_helpers = 1

		-- Show database details by default
		vim.g.db_ui_show_database_icon = 1

		-- Define custom table helpers for common operations
		vim.g.db_ui_table_helpers = {
			postgresql = {
				Count = "select count(*) from {table}",
				Describe = "\\d+ {table}",
			},
			mysql = {
				Count = "select count(*) from {table}",
				Describe = "describe {table}",
			},
			sqlite = {
				Count = "select count(*) from {table}",
				Schema = "select sql from sqlite_master where name = '{table}'",
			},
		}

		-- Example database connections using environment variables
		-- You can also add them via :DBUIAddConnection or pressing 'A' in the drawer
		--
		-- To use environment variables, create a .env file in your project:
		-- DB_UI_DEV=postgres://user:password@localhost:5432/mydb
		-- DB_UI_PROD=mysql://user:password@localhost:3306/mydb
		--
		-- Or set them in your shell:
		-- export DB_UI_DEV="postgres://user:password@localhost:5432/mydb"

		-- Keymaps for quick access
		vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "Toggle [D]ata[B]ase UI" })
		vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "[D]atabase [F]ind Buffer" })
		vim.keymap.set("n", "<leader>da", "<cmd>DBUIAddConnection<cr>", { desc = "[D]atabase [A]dd Connection" })
	end,
}
