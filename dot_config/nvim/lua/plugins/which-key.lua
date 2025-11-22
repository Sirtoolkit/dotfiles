return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec", "disable.ft", "disable.bt" },
	opts = function(_, opts)
		-- Deshabilitar which-key en modo operator-pending para permitir text objects como ciB, diB, etc.
		opts.ignore_missing = true
		opts.operators = false -- Esto desactiva which-key cuando estás en modo operator-pending (c, d, y, etc.)

		-- Asegurar que which-key se active con <leader>
		-- which-key detecta automáticamente las keymaps con 'desc'
		-- Configurar triggers para asegurar que which-key se active
		opts.triggers = opts.triggers or "auto"
		opts.triggers_blacklist = opts.triggers_blacklist or {}

		if not opts.icons then
			opts.icons = {}
		end
		opts.icons.group = ""
		opts.icons.rules = false
		opts.icons.separator = "-"
		if vim.g.icons_enabled == false then
			opts.icons.breadcrumb = ">"
			opts.icons.group = "+"
			opts.icons.keys = {
				Up = "Up",
				Down = "Down",
				Left = "Left",
				Right = "Right",
				C = "Ctrl+",
				M = "Alt+",
				D = "Cmd+",
				S = "Shift+",
				CR = "Enter",
				Esc = "Esc",
				ScrollWheelDown = "ScrollDown",
				ScrollWheelUp = "ScrollUp",
				NL = "Enter",
				BS = "Backspace",
				Space = "Space",
				Tab = "Tab",
				F1 = "F1",
				F2 = "F2",
				F3 = "F3",
				F4 = "F4",
				F5 = "F5",
				F6 = "F6",
				F7 = "F7",
				F8 = "F8",
				F9 = "F9",
				F10 = "F10",
				F11 = "F11",
				F12 = "F12",
			}
		end

		return opts
	end,
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Configuración de iconos de Nerd Fonts
		-- Referencia: https://www.nerdfonts.com/cheat-sheet
		local icons = vim.g.icons_enabled ~= false
				and {
					-- Archivos y Buffers
					file = "󰈔",
					new_file = "󰈙",
					save = "󰆓",
					close = "󰅖",
					-- Navegación
					window = "󰖲",
					buffer = "󰓩",
					-- Terminal
					terminal = "󰆍",
					-- LSP
					lsp = "󰒋",
					code_action = "󰌶",
					references = "󰈇",
					-- Git
					git = "󰊢",
					-- Debug
					debug = "󰆍",
					breakpoint = "󰝥",
					-- Comentarios
					comment = "󰆉",
					-- AI
					ai = "󰚩",
					-- Búsqueda
					search = "󰍉",
					-- Configuración
					config = "󰒓",
				}
			or {}

		-- Función helper para obtener icono con fallback
		local function icon(name)
			local icon_char = icons[name] or ""
			return icon_char ~= "" and (icon_char .. " ") or ""
		end

		-- Registrar todos los grupos con iconos usando wk.register
		-- Esto sobrescribe la detección automática y permite personalizar los nombres

		-- ============================================
		-- GRUPOS DE LEADER
		-- ============================================
		wk.register({
			-- Archivos y Buffers
			w = { name = icon("file") .. "File Operations" },
			q = { name = icon("close") .. "Quit" },
			Q = { name = icon("close") .. "Quit All" },
			n = { name = icon("new_file") .. "New File" },
			x = { name = icon("close") .. "Close Buffer" },
			X = { name = icon("close") .. "Close All Buffers" },
			h = { name = icon("search") .. "Clear Search" },
			-- Terminal
			t = { name = icon("terminal") .. "Terminal" },
			-- LSP y Git
			g = { name = icon("lsp") .. "LSP" },
			["gc"] = { name = icon("git") .. "Git Commit" },
			-- Flutter
			f = { name = "󰟝 Flutter" },
			-- Debug
			d = { name = icon("debug") .. "Debug" },
			-- Comentarios
			["/"] = { name = icon("comment") .. "Comment" },
			-- AI
			a = { name = icon("ai") .. "AI" },
			["ct"] = { name = icon("ai") .. "Copilot Toggle" },
			-- Configuración
			R = { name = icon("config") .. "Reload" },
		}, { prefix = "<leader>" })

		-- ============================================
		-- LSP SIN LEADER (g para go to definition)
		-- ============================================
		wk.register({
			d = { name = icon("lsp") .. "Go to Definition" },
			t = { name = icon("buffer") .. "Next Buffer" },
			T = { name = icon("buffer") .. "Previous Buffer" },
		}, { prefix = "g" })

		-- ============================================
		-- SPACE PARA RENAME
		-- ============================================
		wk.register({
			["rn"] = { name = icon("lsp") .. "Rename" },
		}, { prefix = "<space>" })

		-- ============================================
		-- K PARA HOVER
		-- ============================================
		wk.register({
			K = { name = icon("lsp") .. "Hover" },
		})

		-- ============================================
		-- NAVEGACIÓN DE VENTANAS (Ctrl+)
		-- ============================================
		wk.register({
			["<C-k>"] = { name = icon("window") .. "Window Up" },
			["<C-j>"] = { name = icon("window") .. "Window Down" },
			["<C-h>"] = { name = icon("window") .. "Window Left" },
			["<C-l>"] = { name = icon("window") .. "Window Right" },
		})

		-- ============================================
		-- DEBUG CON F-KEYS
		-- ============================================
		wk.register({
			["<F5>"] = { name = icon("debug") .. "Start/Continue" },
			["<F6>"] = { name = icon("debug") .. "Pause" },
			["<F7>"] = { name = icon("terminal") .. "Toggle Terminal" },
			["<F9>"] = { name = icon("breakpoint") .. "Toggle Breakpoint" },
			["<F10>"] = { name = icon("debug") .. "Step Over" },
			["<F11>"] = { name = icon("debug") .. "Step Into" },
			["<S-F11>"] = { name = icon("debug") .. "Step Out" },
			["<S-F5>"] = { name = icon("debug") .. "Stop" },
			["<C-F5>"] = { name = icon("debug") .. "Restart" },
		})
	end,
}
