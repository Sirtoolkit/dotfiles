return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		-- Interfaz gráfica para el debugger
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
		},
		-- Integración con Mason para instalar debuggers automáticamente
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = { "williamboman/mason.nvim" },
		},
		-- (Opcional) Autocompletado en la consola de depuración
		"rcarriga/cmp-dap",
	},
	-- Teclas que cargan el plugin (Lazy Loading)
	keys = {
		{ "<F5>", desc = "Debugger: Start" },
		{ "<Leader>d", desc = "Debugger Loop" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.adapters.dart = {
			type = "executable",
			command = "dart",
			args = { "debug_adapter" },
		}

		dap.configurations.dart = {
			{
				name = "Launch Current File",
				type = "dart",
				request = "launch",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}

		-- Configurar el adaptador de PHP (que instalamos con Mason)
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = {
				os.getenv("HOME") .. "/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
			},
		}

		-- Configuración de lanzamiento
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 9003, -- El puerto estándar de Xdebug 3
				-- pathMappings son cruciales si usas Docker (Sail)
				pathMappings = {
					["/var/www/html"] = "${workspaceFolder}",
				},
			},
		}

		-- 1. Configurar UI
		dapui.setup({
			floating = { border = "rounded" },
		})

		-- 2. Configurar Mason-Nvim-DAP
		require("mason-nvim-dap").setup({
			automatic_installation = true, -- Intenta instalar adaptadores si faltan
			handlers = {}, -- Asegura que los adaptadores instalados se configuren automáticamente
			ensure_installed = {
				-- "python", -- Ejemplo: puedes forzar instalación aquí
			},
		})

		-- 3. Conectar DAP con UI (Listeners)
		-- Abre la interfaz automáticamente cuando inicias el debugger
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		-- Cierra la interfaz automáticamente cuando terminas (opcional)
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- 4. Configurar Iconos (Signos)
		-- Reemplazo de 'get_icon' de AstroNvim
		local signs = {
			DapBreakpoint = { text = "", texthl = "DiagnosticInfo" },
			DapBreakpointCondition = { text = "", texthl = "DiagnosticInfo" },
			DapBreakpointRejected = { text = "", texthl = "DiagnosticError" },
			DapLogPoint = { text = "", texthl = "DiagnosticInfo" },
			DapStopped = { text = "󰁕", texthl = "DiagnosticWarn" },
		}

		for type, config in pairs(signs) do
			vim.fn.sign_define(type, { text = config.text, texthl = config.texthl, linehl = "", numhl = "" })
		end

		-- 6. Setup de autocompletado (si usas cmp)
		-- Nota: Esto habilita la fuente, pero debes tener nvim-cmp configurado por separado
		require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
			sources = {
				{ name = "dap" },
			},
		})
	end,
}
