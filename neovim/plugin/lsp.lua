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

    vim.keymap.set('n', '<leader>f', vim.lsp.buf.code_action, opts)
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
require('lspconfig').svelte.setup(config)
require('lspconfig').tsserver.setup(config)
