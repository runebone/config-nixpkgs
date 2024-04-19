-- Copied from /etc/nixos/configuration.nix
vim.cmd [[
  set encoding=utf-8
  set nohlsearch
  set clipboard+=unnamedplus

  set tabstop=4
  set shiftwidth=4
  set expandtab

  set t_Co=256
  set bg=dark

  colorscheme gruvbox-material

  set guifont=Mononoki:h10

  set number relativenumber
  set cul
  set cuc
  set colorcolumn=80

  set splitbelow splitright

  inoremap {<CR> {<CR>}<C-o>O
  inoremap [<CR> [<CR>]<C-o>O
  inoremap (<CR> (<CR>)<C-o>O

  inoremap <C-c> <Esc>

  nnoremap j gj
  nnoremap k gk

  au BufRead,BufNewFile *.jai set syntax=rust
  au BufRead,BufNewFile *.tex setlocal spell spelllang=ru,en_us spellsuggest=fast

  " Make gx work
  nnoremap <silent> gx :execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<CR>
]]

vim.g.mapleader = ' '
vim.g.background_color = "dark"
vim.g.airline_theme = "base16" 
-- vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_transparent_background = 2
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1

local gruvbox = "gruvbox"
local darkct = "gruvbox-material"
local lightct = "PaperColor"

function disable_background()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function set_background_light()
    vim.cmd("set background=light")
    vim.g.background_color = "light"
end

function set_background_dark()
    vim.cmd("set background=dark")
    vim.g.background_color = "dark"
end

function toggle_colorscheme()
  if vim.g.colors_name == darkct then
    set_background_light()
    vim.cmd.colorscheme(lightct)
    ColorMyPencils(lightct)
  else
    set_background_dark()
    vim.cmd.colorscheme(darkct)
    ColorMyPencils(darkct)
  end
end

function toggle_light()
  if vim.g.background_color == "dark" then
      set_background_light()
  else
      set_background_dark()
  end
end

function set_gruvbox()
    set_background_dark()
    vim.cmd.colorscheme(gruvbox)
    ColorMyPencils(gruvbox)
end

vim.keymap.set("n", "<leader>s", ":lua toggle_colorscheme()<CR>");
vim.keymap.set("n", "<leader>l", ":lua toggle_light()<CR>");
vim.keymap.set("n", "<leader>d", ":lua disable_background()<CR>");
vim.keymap.set("n", "<leader>g", ":lua set_gruvbox()<CR>");
vim.keymap.set("i", "<C-c>", "<Esc>");
vim.keymap.set("n", "<C-Down>", "VDp==");
vim.keymap.set("n", "<C-Up>", "VDkP==");
