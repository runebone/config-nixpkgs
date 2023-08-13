require('rose-pine').setup({ disable_background = true })

function ColorMyPencils(color) 
	color = color or "gruvbox"

	vim.cmd.colorscheme(color)

    -- Highlight comments using treesitter comment parser
    vim.api.nvim_set_hl(0, "@text.note", { link = "Search" })
end

ColorMyPencils()
