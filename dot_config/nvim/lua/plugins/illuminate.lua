return {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		delay = 200, -- Espera 200ms antes de iluminar (para no molestar mientras te mueves rápido)
		large_file_cutoff = 2000, -- Desactivar si el archivo tiene más de 2000 líneas
		large_file_overrides = {
			providers = { "lsp" }, -- En archivos grandes, usar solo LSP (más rápido que regex)
		},
	},
	config = function(_, opts)
		require("illuminate").configure(opts)

		-- Mapeos opcionales para saltar entre las palabras iluminadas
		-- Simula el comportamiento de n/N pero solo para la palabra bajo el cursor
		local function map(key, dir, buffer)
			vim.keymap.set("n", key, function()
				require("illuminate")["goto_" .. dir .. "_reference"](false)
			end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
		end

		map("]]", "next") -- Saltara a la siguiente aparición con ]]
		map("[[", "prev") -- Saltara a la anterior aparición con [[

		-- También arregla el resaltado para que se vea bonito
		vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
	end,
}
