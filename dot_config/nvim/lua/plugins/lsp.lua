return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
	dependencies = {
		-- Gestor de paquetes (Base)
		"williamboman/mason.nvim",
		-- Instalador automático (Lista de compras)
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- Puente entre Mason y LSPConfig
		"williamboman/mason-lspconfig.nvim",
		-- Capacidades de autocompletado
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
	},
	keys = {
		{ "<Leader>pM", "<Cmd>MasonToolsUpdate<CR>", desc = "Mason Update" },
	},
	config = function()
		-- IMPORTACIONES
		local lspconfig = require("lspconfig")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- =======================================================
		-- 1. INICIAMOS MASON (Base)
		-- =======================================================
		-- Al hacerlo aquí primero, garantizamos que el registro exista.
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- =======================================================
		-- 2. INSTALAMOS HERRAMIENTAS (Logística)
		-- =======================================================
		mason_tool_installer.setup({
			ensure_installed = {
				-- LUA
				"lua-language-server",
				"stylua", -- Formateador recomendado para Lua

				-- WEB / JS
				"js-debug-adapter",
				"graphql-language-service-cli",

				-- SHELL
				"bash-language-server",
				"beautysh",

				-- DEVOPS & LINTERS
				"dotenv-linter",
				"actionlint",
				"cfn-lint",
				"circleci-yaml-language-server",
				"gh-actions-language-server",
				"vacuum",

				-- == PHP / LARAVEL ==
				"intelephense", -- El mejor LSP para PHP (Autocompletado rápido)
				"php-debug-adapter", -- Para Xdebug (Debugging)
				"blade-formatter", -- Formateador para archivos .blade.php
				"pint", -- Linter/Formateador oficial de Laravel

				-- == WEB & JS/TS ==
				"typescript-language-server",
				"tailwindcss-language-server",
				"eslint_d", -- Linter para JS/TS
				"prettier", -- Formateador universal
				"prisma-language-server",

				-- == JAVA / KOTLIN ==
				"jdtls", -- Java LSP (Esencial)
				"google-java-format", -- Formateador Java
				"groovy-language-server",
				"kotlin-language-server",
				"ktfmt",
				"ktlint",

				-- == INFRAESTRUCTURA ==
				"terraform-ls",
				"tflint",
				"dockerfile-language-server",
				"hadolint", -- Linter para Dockerfiles
				"yaml-language-server",
				"json-lsp",
				"lemminx", -- XML LSP

				-- == OTROS ==
				"swiftlint", -- Swift (El LSP de Swift suele usar el de Xcode, sourcekit)
			},
			-- Integraciones desactivadas porque las manejamos abajo manualmente
			integrations = {
				["mason-lspconfig"] = false,
				["mason-null-ls"] = false,
				["mason-nvim-dap"] = false,
			},
		})

		-- =======================================================
		-- 3. CONFIGURACIÓN LSP (Cerebro)
		-- =======================================================

		-- Configuración previa (Neoconf y Capabilities)
		require("neoconf").setup({})

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

		-- Configuración de Mason-LSPConfig (El Conector)
		mason_lspconfig.setup({
			handlers = {
				-- Handler por defecto (para todo lo instalado por Mason)
				function(server_name)
					-- EXCEPCIÓN: Ignorar dartls (lo maneja flutter-tools)
					if server_name == "dartls" then
						return
					end

					-- 2. PROTECCIÓN CONTRA ERRORES (La solución al crash)
					-- Verificamos si 'lspconfig' realmente conoce este servidor.
					-- Si es un paquete basura (como "framework"), esto devuelve false y evitamos el error.
					local valid_server = pcall(function()
						return lspconfig[server_name]
					end)
					if not valid_server or not lspconfig[server_name] then
						return -- Ignoramos silenciosamente el servidor inválido
					end

					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		})

		-- =======================================================
		-- 4. FORMATEO AUTOMÁTICO
		-- =======================================================
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
			callback = function(args)
				vim.lsp.buf.format({
					async = false,
					bufnr = args.buf,
				})
			end,
		})
	end,
}
