{ config, pkgs, ... }:

with {
  LUA_CONFIG = "$HOME/.config/nixpkgs/neovim/main.lua";
};

# TODO: clean this up
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
      julia-vim

      indentLine

      # Git
      vim-fugitive

      # NerdTree-like plugin
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          -- examples for your init.lua

          -- disable netrw at the very start of your init.lua (strongly advised)
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1

          -- set termguicolors to enable highlight groups
          vim.opt.termguicolors = true

          -- empty setup using defaults
          require("nvim-tree").setup()

          -- OR setup with some options
          require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
              width = 30,
              mappings = {
                list = {
                  { key = "u", action = "dir_up" },
                },
              },
            },
            renderer = {
              group_empty = true,
            },
            filters = {
              dotfiles = true,
            },
          })
        '';
      }
      nvim-web-devicons

      # Fuzzy finder
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<leader>pf", builtin.find_files, {}) -- project files
          vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        '';
      }

      # Syntax parser and highlighter, will highlight user-defined functions
      {
        plugin = (nvim-treesitter.withPlugins (
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
          ]
          ));
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup {
            -- Equivalent to ":TSEnable highlight"
            highlight = {
              enable = true,
            };
          }
        '';
      }

      # LSP
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        local opts = { buffer = bufnr }
        local lsp_attach = function(client, bufnr)
          vim.keymap.set('n', '<F4>', vim.cmd.ClangdSwitchSourceHeader)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('i', '<C-l>', vim.lsp.buf.completion, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
        end

        local config = {
          on_attach = lsp_attach,
          capabilities = lsp_capabilities
        }

        require('lspconfig').clangd.setup(config)
        require('lspconfig').gopls.setup(config)
        require('lspconfig').pyright.setup(config)
        require('lspconfig').rust_analyzer.setup(config)
        require('lspconfig').rnix.setup(config)
        require('lspconfig').julials.setup(config)
        '';
      }

      # Autocompletion
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
        -- set completeopt = menu,menuone,noselect

        -- Set up nvim-cmp.
        local cmp = require'cmp'

        cmp.setup({
          snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
          },
          window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-l>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users.
          }, {
            { name = 'buffer' },
          })
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
          }, {
            { name = 'buffer' },
          })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        -- AOAOAOAAOOAAAOA some luasnip config... man I have to clean this shit up some day
        local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")

        cmp.setup({

          -- ... Your other configuration ...

          mapping = {

            -- ... Your other mappings ...

            ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            elseif has_words_before() then
            cmp.complete()
            else
            fallback()
            end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
            cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
            else
            fallback()
            end
            end, { "i", "s" }),

            -- ... Your other mappings ...
          },

          -- ... Your other configuration ...
        })
        '';
      }

      # Continue Autocompletion
      # cmp-buffer
      # cmp-path
      cmp_luasnip # Luasnip completion source for luasnip
      cmp-nvim-lsp
      cmp-nvim-lua

      # Snippets
      luasnip # Snippet engine

      {
        plugin = refactoring-nvim;
        type = "lua";
        config = ''
        require('refactoring').setup({
          prompt_func_return_type = {
            go = false,
            java = false,

            cpp = true,
            c = true,
            h = true,
            hpp = true,
            cxx = true,
          },
          prompt_func_param_type = {
            go = false,
            java = false,

            cpp = true,
            c = true,
            h = true,
            hpp = true,
            cxx = true,
          },
          printf_statements = {},
          print_var_statements = {
            cpp = {
              'printf("a custom statement %%s %s", %s)'
            }
          },
        })

        -- Remaps for the refactoring operations currently offered by the plugin
        vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
        vim.api.nvim_set_keymap("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
        vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
        vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

        -- Extract block doesn't need visual mode
        vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], {noremap = true, silent = true, expr = false})
        vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], {noremap = true, silent = true, expr = false})

        -- Inline variable can also pick up the identifier currently under the cursor without visual mode
        vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

        -- You can also use below = true here to to change the position of the printf
        -- statement (or set two remaps for either one). This remap must be made in normal mode.
        vim.api.nvim_set_keymap(
          "n",
          "<leader>rp",
          ":lua require('refactoring').debug.printf({below = false})<CR>",
          { noremap = true }
          )

          -- Print var

          -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
          vim.api.nvim_set_keymap("n", "<leader>rv", ":lua require('refactoring').debug.print_var({ normal = true })<CR>", { noremap = true })
          -- Remap in visual mode will print whatever is in the visual selection
          vim.api.nvim_set_keymap("v", "<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })

          -- Cleanup function: this remap should be made in normal mode
          vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })
          '';
      }
    ];

    extraConfig = ''
      luafile ${LUA_CONFIG}
    '';
  };
}
