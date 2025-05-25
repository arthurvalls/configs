return {
  'tomasiser/vim-code-dark',
  codedark_modern = true,
  codedark_italics = true,
  airline_theme = 'codedark',
  config = function()
    vim.cmd.colorscheme 'codedark'
    vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = '#000000' })
    require('notify').setup {
      background_colour = 'NotifyBackground',
    }
  end,
}
