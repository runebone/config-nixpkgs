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

  colorscheme gruvbox

  set guifont=Mononoki:h10

  set number relativenumber
  set cul
  set cuc
  set colorcolumn=80

  set splitbelow splitright

  inoremap {<CR> {<CR>}<C-o>O
  inoremap [<CR> [<CR>]<C-o>O
  inoremap (<CR> (<CR>)<C-o>O
]]

vim.g.mapleader = ' '
vim.g.background_color = "dark"
vim.g.airline_theme = "base16" 

function disable_background()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

disable_background()

function set_background_light()
    vim.cmd("set background=light")
    vim.g.background_color = "light"
end

function set_background_dark()
    vim.cmd("set background=dark")
    vim.g.background_color = "dark"
end

function toggle_colorscheme()
  if vim.g.colors_name == "gruvbox" then
    -- vim.cmd("set background=light")
      set_background_light()
    vim.cmd("colorscheme PaperColor")
    vim.cmd("AirlineTheme papercolor")
  else
    -- vim.cmd("set background=dark")
      set_background_dark()
    vim.cmd("colorscheme gruvbox")
    vim.cmd("AirlineTheme gruvbox")
    disable_background()
  end
end

function toggle_dark()
  if vim.g.background_color == "dark" then
      set_background_light()
  else
      set_background_dark()
  end
end

vim.keymap.set("n", "<leader>s", ":lua toggle_colorscheme()<CR>");
vim.keymap.set("n", "<leader>d", ":lua disable_background()<CR>");
vim.keymap.set("n", "<leader>l", ":lua toggle_dark()<CR>");
