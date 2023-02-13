-- Copied from /etc/nixos/configuration.nix
vim.cmd [[
  set encoding=utf-8
  set nohlsearch
  set clipboard+=unnamedplus

  set tabstop=4
  set shiftwidth=4
  set expandtab

  set autochdir

  set t_Co=256
  set bg=dark
  colorscheme srcery

  set guifont=Mononoki:h12

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
