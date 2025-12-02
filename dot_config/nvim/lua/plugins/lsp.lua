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

				-- == ANDROID / KOTLIN ==
				"kotlin-language-server",
				"ktlint",
				"groovy-language-server",

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

					-- Lista negra de servidores inválidos
					local invalid_servers = { "framework" }
					for _, invalid in ipairs(invalid_servers) do
						if server_name == invalid then
							return
						end
					end

					-- PROTECCIÓN CONTRA ERRORES: Verificar que el servidor existe en lspconfig
					local ok = pcall(function()
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end)
					
					if not ok then
						vim.notify("Failed to setup LSP server: " .. server_name, vim.log.levels.WARN)
					end
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

		require("lspconfig").intelephense.setup({
			settings = {
				intelephense = {
					filetypes = { "php", "blade", "php_only" },
					files = {
						maxSize = 5000000, -- Aumentar el tamaño máximo de archivo
					},
					-- Excluir carpetas basura que no necesitas para autocompletado
					exclude = {
						"**/node_modules/**",
						"**/vendor/**/Tests/**",
						"**/vendor/**/tests/**",
						"**/storage/**",
						"**/public/**",
					},
				},
			},
			-- Esto ayuda a que encuentre la raíz del proyecto correctamente
			root_dir = require("lspconfig").util.root_pattern("composer.json", ".git"),
		})

		require("conform").setup({
			formatters_by_ft = {
				php = { "pint" }, -- Usa Pint para PHP estándar
				blade = { "blade-formatter" }, -- Usa blade-formatter para .blade.php
			},
			-- Formatear al guardar (sin bloquear si tarda mucho)
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = false, -- NO usar el formateo de Intelephense
			},
		})

		vim.opt.wildignore:append({ "*/node_modules/*", "*/vendor/*", "*/storage/*" })
	end,
}
