-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- vim options
require("config.options")

vim.lsp.log.set_level(vim.log.levels.OFF)

-- vim keymaps
require("config.keymaps")

-- Terminal colorscheme sync (kitty + ghostty + wezterm). Registers a
-- ColorScheme autocmd, so it must load BEFORE lazy.setup runs the active
-- colorscheme plugin's `vim.cmd.colorscheme(...)`.
require("config.terminal-sync")

-- Disable unused providers (silences :checkhealth provider warnings)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Disable built-in plugins we don't use (saves ~5ms on startup).
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1 -- oil.nvim replaces netrw
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_2html_plugin = 1

-- Load plugins
require("lazy").setup(require("config.plugins"), {
	rocks = { hererocks = false },
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- No active colorscheme plugin here — the active scheme is set by the
-- individual plugin spec (see lua/config/plugins/crucible.lua), which uses
-- a VimEnter autocmd so it wins the race against the other theme plugins.
-- Alternatives: `habamax`, `industry`, `quiet`, `default`.
-- vim.cmd.colorscheme("industry")

vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
