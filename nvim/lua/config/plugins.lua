-- lua/config/plugins.lua
return {
	-- require('config.plugins.e-ink'),
	-- require("config.plugins.iceberg"),
	-- require("config.plugins.cyberpunk"),
	-- require("config.plugins.blueberry-peach"),
	-- require("config.plugins.colorscheme"), -- nerv dark theme (inactive)
	-- require("config.plugins.melange"), -- melange light (inactive)
	-- require("config.plugins.selenized"), -- selenized light (inactive)
	-- require("config.plugins.solarized"), -- solarized light (inactive)
	-- require("config.plugins.tinted"),
	require("config.plugins.smear-cursor"),
	-- require("config.plugins.black_metal"),
	require("config.plugins.stylua"),
	require("config.plugins.multi"),
	-- require("config.plugins.gruvbox"),
	-- require("config.plugins.tokyo"),
	require("config.plugins.nightfox"),
	require("config.plugins.solarized-osaka"),
	-- require 'config.plugins.base16',
	-- require("config.plugins.darcula"),
	-- require("config.plugins.notify"), -- replaced by snacks.notifier
	require("config.plugins.leetcode"),
	require("config.plugins.dashboard"),
	require("config.plugins.dadbod"),
	-- require("config.plugins.autocomplete"), -- replaced by blink.cmp
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
	require("kickstart.plugins.gitsigns"),
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
	require("config.plugins.rainbow-delimiters"),
	require("config.plugins.highlight-colors"),
}
