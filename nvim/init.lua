-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
-- vim options
require 'config.options'

vim.lsp.log.set_level(vim.log.levels.OFF)

-- vim keymaps
require 'config.keymaps'

-- Terminal colorscheme sync (kitty + ghostty + wezterm). Registers a
-- ColorScheme autocmd, so it must load BEFORE lazy.setup runs the active
-- colorscheme plugin's `vim.cmd.colorscheme(...)`.
require 'config.terminal-sync'

-- Load plugins
require('lazy').setup(require 'config.plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
