-- lua/config/plugins.lua
return {
	-- Active (and only) colorscheme: gruvbox (ellisonleao/gruvbox.nvim),
	-- hard contrast with a vantablack-like (#0a0a0a) background override.
	-- Kitty palette mirrored at ~/.config/kitty/gruvbox.conf via terminal-sync.lua.
	require("config.plugins.gruvbox"),
	require("config.plugins.smear-cursor"),
	require("config.plugins.stylua"),
	require("config.plugins.multi"),
	-- require("config.plugins.notify"), -- replaced by snacks.notifier
	require("config.plugins.dashboard"),
	require("config.plugins.dadbod"),
	require("config.plugins.autoformat"),
	require("config.plugins.dap"),
	require("config.plugins.devicons"),
	require("config.plugins.gitsigns"),
	require("config.plugins.lazydev"),
	require("config.plugins.lspconfig"),
	require("config.plugins.mini"),
	require("config.plugins.neotest-java"),
	require("config.plugins.neotest"),
	require("config.plugins.noice"),
	require("config.plugins.telescope"),
	require("config.plugins.todo-comments"),
	--  require 'config.plugins.transparent',
	require("config.plugins.treesitter"),
	require("config.plugins.vim-sleuth"),
	require("config.plugins.which-key"),
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.neo-tree"),
	-- gitsigns consolidated into config/plugins/gitsigns.lua (signs + keymaps)
	require("kickstart.plugins.lint"),
	require("kickstart.plugins.debug"),
	-- require("kickstart.plugins.indent_line"), -- replaced by snacks.indent

	-- New plugins
	require("config.plugins.snacks"),
	require("config.plugins.blink"),
	require("config.plugins.flash"),
	require("config.plugins.bufferline"),
	require("config.plugins.dropbar"),
	require("config.plugins.trouble"),
	require("config.plugins.lualine"),
	require("config.plugins.undotree"),
	require("config.plugins.oil"),
	require("config.plugins.persistence"),
	require("config.plugins.neoscroll"),
	-- require("config.plugins.rainbow-delimiters"),
	require("config.plugins.highlight-colors"),
	-- require("config.plugins.render-markdown"), -- disabled: yields-across-C-boundary on nvim 0.12-dev, update plugin then re-enable
	require("config.plugins.grug-far"),
}
