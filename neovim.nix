{ config, pkgs, ... }:
{
  # Initial configuration is in /etc/nixos/configuration.nix
  programs.neovim = {
    enable = true;

    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Plugins, copied from /etc/nixos/configuration.nix
      vim-nix
      vim-surround
      vim-commentary
      vim-airline
      vim-css-color
      srcery-vim

      # Other plugins
      vim-go
      vim-glsl
    ];

    extraConfig = ''
      " Copied from /etc/nixos/configuration.nix
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

      " Other settings
    '';
  };
}
