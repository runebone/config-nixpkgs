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

local lspc = require('lspconfig')

lspc.clangd.setup(config)
lspc.gopls.setup(config)
lspc.pyright.setup(config)
lspc.rust_analyzer.setup(config)
lspc.rnix.setup(config)
lspc.julials.setup(config)
lspc.svelte.setup(config)
lspc.tsserver.setup(config)
lspc.lua_ls.setup(config)
lspc.bashls.setup(config)

local java_config = {
    on_attach = lsp_attach,
    capabilities = lsp_capabilities,
    cmd = { 'jdt-language-server' }
}
lspc.jdtls.setup(java_config)

-- Lua
require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})
