vim.opt.clipboard = "unnamedplus"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.guicursor = "n-v-i:block"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
-- Toggle Netrw with <leader>e
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { silent = true })
