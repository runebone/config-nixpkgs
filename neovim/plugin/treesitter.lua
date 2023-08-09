require'nvim-treesitter.configs'.setup {
    -- Equivalent to ":TSEnable highlight"
    highlight = {
        enable = true,
    };
}

vim.keymap.set("n", "<leader>tt", ":TSToggle highlight<CR>");
