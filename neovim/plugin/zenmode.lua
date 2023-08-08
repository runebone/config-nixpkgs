local value = 1

if vim.g.neovide then value = 0 end

vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").setup {
        window = {
            backdrop = value,
            width = 100,
            options = { }
        },
    }
    require("zen-mode").toggle()
    vim.wo.wrap = false
    vim.wo.number = true
    vim.wo.rnu = true
    ColorMyPencils()
end)

vim.keymap.set("n", "<leader>zZ", function()
    require("zen-mode").setup {
        window = {
            backdrop = value,
            width = 80,
            options = { }
        },
    }
    require("zen-mode").toggle()
    vim.wo.wrap = false
    vim.wo.number = false
    vim.wo.rnu = false
    vim.opt.colorcolumn = "0"
    ColorMyPencils()
end)
