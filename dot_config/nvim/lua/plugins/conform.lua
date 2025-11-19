return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim", -- Aseguramos que Mason esté listo
	},
	config = function()
		local conform = require("conform")

		conform.setup({
			-- Definimos qué formateador usar para cada archivo
			formatters_by_ft = {
				php = { "pint" },
				blade = { "blade-formatter" },
				json = { "jq" },
			},

			-- Configuración vital para que NO se congele ni borre archivos
			format_on_save = {
				-- Si Pint tarda más de 1 segundo, no bloquea el editor,
				-- formateará la próxima vez o esperará un poco más.
				timeout_ms = 2000,
				lsp_fallback = false, -- No usar el formateo del LSP (Intelephense)
			},
		})
	end,
}
