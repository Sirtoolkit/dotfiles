return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			mode = "buffers",
			separator_style = "thin",
			always_show_bufferline = true,
			diagnostics = "nvim_lsp", -- Muestra errores en la pestaña
			-- Mueve la barra si abres Neo-tree
			offsets = {
				{
					filetype = "neo-tree",
					text = "Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	},
}
