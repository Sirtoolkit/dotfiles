return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec", "disable.ft", "disable.bt" },
	opts = function(_, opts)
		-- Configurar delay (tiempo antes de mostrar el popup)
		opts.delay = 200 -- milisegundos (ajusta según prefieras)

		-- Configurar triggers (debe ser una tabla, no "auto")
		-- which-key detecta automáticamente las keymaps con 'desc'
		-- Si no hay triggers definidos, usar detección automática
		if not opts.triggers or opts.triggers == "auto" then
			opts.triggers = nil -- nil permite detección automática completa
		end

		-- Nota: Las opciones antiguas (operators, ignore_missing, triggers_blacklist)
		-- han sido reemplazadas por defer y filter, pero los valores por defecto
		-- de which-key ya proporcionan el comportamiento deseado

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

		-- ============================================
		-- REGISTROS MANUALES
		-- Which-key detecta automáticamente todos los keymaps con 'desc'
		-- Solo registramos manualmente keymaps que NO tienen 'desc'
		-- Usando el nuevo formato de spec (v3.x)
		-- ============================================

		-- Setup con configuración
		wk.setup(opts)

		-- Registrar grupos de leader keys
		-- Usando el nuevo formato de spec (v3.x)
		wk.add({
			{ "<leader>a", group = "AI" },
			{ "<leader>c", group = "Copilot" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>f", group = "Flutter" },
			{ "<leader>g", group = "Git" },
			{ "<leader>t", group = "Terminal/Tabs" },
		})

		-- Nota: Todos los demás keymaps (con 'desc') se detectan automáticamente:
		-- - Grupos de leader (t, g, f, d, a) y sus keymaps hijos
		-- - Keymaps directos (w, q, h, n, x, X, Q, /)
		-- - Keymaps sin leader (gd, gt, gT, K, <space>rn)
		-- - F-keys de debug
	end,
}
