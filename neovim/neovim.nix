{ config, pkgs, ... }:

with {
  LUA_CONFIG = "$HOME/.config/home-manager/neovim/main.lua";
  PLUGIN_DIR = "$HOME/.config/home-manager/neovim/plugin";
};

let EXTRA_CONFIG = ''
  luafile ${LUA_CONFIG}
  luafile ${PLUGIN_DIR}/cmp_luasnip.lua
  luafile ${PLUGIN_DIR}/colors.lua
  luafile ${PLUGIN_DIR}/harpoon.lua
  luafile ${PLUGIN_DIR}/lsp.lua
  luafile ${PLUGIN_DIR}/nvim-tree.lua
  luafile ${PLUGIN_DIR}/oil.lua
  luafile ${PLUGIN_DIR}/refactoring.lua
  luafile ${PLUGIN_DIR}/telescope.lua
  luafile ${PLUGIN_DIR}/treesitter.lua
  luafile ${PLUGIN_DIR}/trouble.lua
  luafile ${PLUGIN_DIR}/undotree.lua
  luafile ${PLUGIN_DIR}/zenmode.lua
''; in
{
  # Initial configuration is in /etc/nixos/configuration.nix
  programs.neovim = {
    enable = true;

    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Basic quality of life improvements
      vim-surround
      vim-commentary
      vim-repeat
      indentLine
      # todo-comments-nvim
      trouble-nvim

      vim-airline
      vim-airline-themes
      vim-css-color

      # Colorschemes
      # awesome-vim-colorschemes
      srcery-vim
      papercolor-theme
      rose-pine
      tokyonight-nvim
      gruvbox-nvim
      kanagawa-nvim
      gruvbox-material

      # Other plugins
      vim-nix
      vim-go
      vim-glsl
      julia-vim
      vim-svelte
      # emmet-vim

      # Git
      vim-fugitive

      # Blazingly fast navigation
      harpoon

      # NerdTree-like plugin
      nvim-tree-lua
      nvim-web-devicons
      oil-nvim

      # Fuzzy finder
      telescope-nvim

      # Syntax parser and highlighter, will highlight user-defined functions
      {
        plugin = nvim-treesitter.withPlugins (
          plugins: with plugins; [
            bash
            bibtex
            c
            c_sharp
            cmake
            comment
            commonlisp
            cpp
            csv
            dockerfile
            glsl
            go
            java
            javascript
            json
            julia
            latex
            lua
            make
            nix
            python
            rust
            svelte
            toml
            typescript
            vim
            zig
          ]
        );
        type = "lua";
      }
      nvim-treesitter-context

      # LSP
      nvim-lspconfig
      lsp-colors-nvim
      # nvim-jdtls # Java...

      # Autocompletion
      nvim-cmp

      # Continue Autocompletion
      # cmp-buffer
      # cmp-path
      cmp_luasnip # Luasnip completion source for luasnip
      cmp-nvim-lsp
      cmp-nvim-lua

      # Snippets
      luasnip # Snippet engine
      friendly-snippets

      # Refactoring
      refactoring-nvim

      undotree
      zen-mode-nvim
    ];

    extraConfig = EXTRA_CONFIG;
  };
}
