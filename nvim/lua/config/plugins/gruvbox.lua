return {
  'ellisonleao/gruvbox.nvim',
  lazy = false, -- load during startup so the colorscheme is ready ASAP
  priority = 1000, -- make sure it happens before anything else that might set colors
  opts = {
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
    inverse = true, -- inverse for search, diff, etc.
    contrast = 'soft', -- "hard", "soft", or leave empty
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  },
  config = function(_, opts)
    require('gruvbox').setup(opts)
    vim.cmd.colorscheme 'gruvbox'
  end,
}
