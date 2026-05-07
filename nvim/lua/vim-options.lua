vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")
vim.cmd("set number")
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-v>', '"+p')
vim.keymap.set('i', '<C-v>', '"+p')
