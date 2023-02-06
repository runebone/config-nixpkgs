-- Copied from /etc/nixos/configuration.nix
vim.cmd [[
  set encoding=utf-8
  set nohlsearch
  set clipboard+=unnamedplus
  set bg=dark

  set tabstop=4
  set shiftwidth=4
  set expandtab

  set autochdir

  set t_Co=256
  colorscheme srcery

  set number relativenumber
  set cul
  set cuc
  set colorcolumn=80

  inoremap {<CR> {<CR>}<C-o>O
  inoremap [<CR> [<CR>]<C-o>O
  inoremap (<CR> (<CR>)<C-o>O
]]

vim.g.mapleader = ' '

vim.keymap.set("n", "<leader>n", vim.cmd.NvimTreeToggle);
