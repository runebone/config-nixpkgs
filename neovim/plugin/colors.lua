require('rose-pine').setup({ disable_background = true })

function ColorMyPencils(color)
	color = color or "gruvbox-material"

	vim.cmd.colorscheme(color)

    if not color == "PaperColor" then
        disable_background()
    end

    -- Highlight comments using treesitter comment parser
    -- vim.api.nvim_set_hl(0, "@text.note", { link = "Search" })
end

ColorMyPencils()
