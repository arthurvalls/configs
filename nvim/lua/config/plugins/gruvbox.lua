return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  terminal_colors = true,
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = 'hard', -- can be "hard", "soft" or empty string
  dim_inactive = false,
  transparent_mode = false,
  config = function()
    vim.cmd 'colorscheme gruvbox'
  end,
}
