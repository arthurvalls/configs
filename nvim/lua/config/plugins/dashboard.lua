return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'doom',
      config = {
        header = {
          '  __        __   _ _',
          '  \\ \\      / /__| | | ___ ',
          '   \\ \\ /\\ / / _ \\ | |/ _ \\',
          '    \\ V  V /  __/ | | (_) |',
          '     \\_/\\_/ \\___|_|_|\\___/',
        },
        center = {
          {
            icon = ' ',
            icon_hl = 'DashboardIcon',
            desc = 'Find File',
            desc_hl = 'DashboardDesc',
            key = 'f',
            key_hl = 'DashboardKey',
            key_format = ' [%s]',
            action = 'Telescope find_files',
          },
          {
            icon = '󰊖 ',
            icon_hl = 'DashboardIcon',
            desc = 'New File',
            desc_hl = 'DashboardDesc',
            key = 'n',
            key_hl = 'DashboardKey',
            key_format = ' [%s]',
            action = 'ene | startinsert',
          },
          {
            icon = ' ',
            icon_hl = 'DashboardIcon',
            desc = 'Recent Files',
            desc_hl = 'DashboardDesc',
            key = 'r',
            key_hl = 'DashboardKey',
            key_format = ' [%s]',
            action = 'Telescope oldfiles',
          },
          {
            icon = '﬌ ',
            icon_hl = 'DashboardIcon',
            desc = 'Find Text',
            desc_hl = 'DashboardDesc',
            key = 'g',
            key_hl = 'DashboardKey',
            key_format = ' [%s]',
            action = 'Telescope live_grep',
          },
          {
            icon = ' ',
            icon_hl = 'DashboardIcon',
            desc = 'Quit Neovim',
            desc_hl = 'DashboardDesc',
            key = 'q',
            key_hl = 'DashboardKey',
            key_format = ' [%s]',
            action = 'qa',
          },
        },
        footer = {
          'Press ? to show shortcuts',
          'Edit $MYVIMRC to change this',
        },
        vertical_center = true,
      },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
