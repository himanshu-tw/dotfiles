return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'doom',
      config = {
        header = {
          "                                                     ",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "                                                     ",
},
        center = {
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Find File',
            desc_hl = 'String',
            key = 'f',
            key_format = ' %s',
            action = 'Telescope find_files',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Live Grep',
            desc_hl = 'String',
            key = 'g',
            key_format = ' %s',
            action = 'Telescope live_grep',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Config',
            desc_hl = 'String',
            key = 'c',
            key_format = ' %s',
            action = 'e ~/.config/nvim/init.lua',
          },
          {
            icon = '󰒲 ',
            icon_hl = 'Title',
            desc = 'Lazy Update',
            desc_hl = 'String',
            key = 'u',
            key_format = ' %s',
            action = 'Lazy update',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Quit',
            desc_hl = 'String',
            key = 'q',
            key_format = ' %s',
            action = 'qa',
          },
        },
        footer = { "himanshu-tw" },
      },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
