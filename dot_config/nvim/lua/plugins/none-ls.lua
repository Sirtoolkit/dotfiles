return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"williamboman/mason.nvim", -- Asegúrate de tener mason cargado
		{
			"jay-babu/mason-null-ls.nvim",
			cmd = { "NullLsInstall", "NullLsUninstall" },
		},
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local mason_null_ls = require("mason-null-ls")

		-- 1. Configurar el puente entre Mason y Null-ls
		-- Esto reemplaza a: require "astronvim.plugins.configs.mason-null-ls"
		mason_null_ls.setup({
			ensure_installed = {}, -- Pon aquí herramientas si quieres forzar su instalación (ej. "prettier", "stylua")
			automatic_installation = true, -- Intenta instalar automáticamente si falta algo
			handlers = {}, -- Deja esto vacío para usar la configuración por defecto de cada herramienta
		})

		-- 2. Configurar None-ls
		null_ls.setup({
			sources = {},
			on_attach = function(client, bufnr) end,
		})
	end,
}
