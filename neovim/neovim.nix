{ config, pkgs, ... }:

with {
  LUA_CONFIG = "$HOME/.config/nixpkgs/neovim/main.lua";
  PLUGIN_DIR = "$HOME/.config/nixpkgs/neovim/plugin";
};

let EXTRA_CONFIG = ''
  luafile ${LUA_CONFIG}
  luafile ${PLUGIN_DIR}/cmp_luasnip.lua
  luafile ${PLUGIN_DIR}/colors.lua
  luafile ${PLUGIN_DIR}/harpoon.lua
  luafile ${PLUGIN_DIR}/lsp.lua
  luafile ${PLUGIN_DIR}/nvim-tree.lua
  luafile ${PLUGIN_DIR}/refactoring.lua
  luafile ${PLUGIN_DIR}/telescope.lua
  luafile ${PLUGIN_DIR}/treesitter.lua
  luafile ${PLUGIN_DIR}/zenmode.lua
''; in
{
  # Initial configuration is in /etc/nixos/configuration.nix
  programs.neovim = {
    enable = true;

    vimAlias = false;

    plugins = with pkgs.vimPlugins; [
      # Basic quality of life improvements
      vim-surround
      vim-commentary
      vim-repeat
      indentLine
      todo-comments-nvim
      trouble-nvim

      vim-airline
      vim-airline-themes
      vim-css-color

      # Colorschemes
      awesome-vim-colorschemes
      srcery-vim
      papercolor-theme
      rose-pine

      # Other plugins
      vim-nix
      vim-go
      vim-glsl
      julia-vim
      vim-svelte
      emmet-vim

      # Git
      vim-fugitive

      # Blazingly fast navigation
      harpoon

      # Debugger
      nvim-dap
      nvim-dap-ui
      telescope-dap-nvim
      # nvim-dap-virtual-text

      # NerdTree-like plugin
      nvim-tree-lua
      nvim-web-devicons

      # Fuzzy finder
      telescope-nvim

      # Syntax parser and highlighter, will highlight user-defined functions
      {
        plugin = nvim-treesitter.withPlugins (
          plugins: with plugins; [
            c
            cmake
            cpp
            glsl
            go
            javascript
            latex
            lua
            make
            nix
            python
            rust
            typescript
            vim
            comment
          ]
        );
        type = "lua";
      }
      nvim-treesitter-context

      # LSP
      nvim-lspconfig
      lsp-colors-nvim

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

      zen-mode-nvim
    ];

    extraConfig = EXTRA_CONFIG;
  };
}
