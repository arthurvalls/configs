-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  -- No nvim-cmp dependency: blink.cmp is the completion engine; autopairs
  -- works standalone via check_ts. (Was installing an unused nvim-cmp.)
  config = function()
    require('nvim-autopairs').setup {
      check_ts = true,
      ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
        java = false,
      },
    }
  end,
}
