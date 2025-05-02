return {
  'rcarriga/nvim-notify',
  config = function()
    vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = '#000000' })
    require('notify').setup {
      background_colour = 'NotifyBackground',
    }
  end,
}
