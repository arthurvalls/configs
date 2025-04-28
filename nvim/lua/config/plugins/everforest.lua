return {
  'sainnhe/everforest',
  config = function()
    vim.g.everforest_better_performance = 1
    vim.g.everforest_background = 'medium'
    vim.g.everforest_enable_italic = true
    vim.cmd 'colorscheme everforest'
  end,
}
