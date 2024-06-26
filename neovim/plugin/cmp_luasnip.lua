-- set completeopt = menu,menuone,noselect

-- Set up nvim-cmp.
-- local cmp = require('cmp')

-- local has_words_before = function()
--     unpack = unpack or table.unpack
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

function SetupCmp()
    local cmp = require('cmp')
    -- local luasnip = require("luasnip")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        }),
        -- window = {
        --     -- completion = cmp.config.window.bordered(),
        --     -- documentation = cmp.config.window.bordered(),
        -- },
        -- mapping = cmp.mapping.preset.insert({
        --     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        --     ['<C-f>'] = cmp.mapping.scroll_docs(4),
        --     ['<C-Space>'] = cmp.mapping.complete(),
        --     -- ['<C-j>'] = cmp.mapping.abort(),
        --     ['<C-c>'] = cmp.mapping.abort(),
        --     -- ['<C-l>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --     ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --     -- ["<Tab>"] = cmp.mapping(function(fallback)
        --     -- ["<C-l>"] = cmp.mapping(function(fallback)
        --     -- ["<C-h>"] = cmp.mapping(function(fallback)
        --     ["<C-s>;"] = cmp.mapping(function(fallback)
        --         if cmp.visible() then
        --             cmp.select_next_item()
        --             -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
        --             -- they way you will only jump inside the snippet region
        --         elseif luasnip.expand_or_jumpable() then
        --             luasnip.expand_or_jump()
        --         elseif has_words_before() then
        --             cmp.complete()
        --         else
        --             fallback()
        --         end
        --     end, { "i", "s" }),

        --     -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --     -- ["<C-h>"] = cmp.mapping(function(fallback)
        --     -- ["<C-t>"] = cmp.mapping(function(fallback)
        --     ["<C-s>,"] = cmp.mapping(function(fallback)
        --         if cmp.visible() then
        --             cmp.select_prev_item()
        --         elseif luasnip.jumpable(-1) then
        --             luasnip.jump(-1)
        --         else
        --             fallback()
        --         end
        --     end, { "i", "s" }),
        -- }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' }, -- For luasnip users.
        }, {
            { name = 'buffer' },
        })
    })
end

SetupCmp()

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({paths = "~/.config/home-manager/neovim/snippets"})

local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-s>e", function() ls.expand() end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-s>;", function() ls.jump(1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-s>,", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, {silent = true})

-- vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
