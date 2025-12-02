return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			mux = {
				backend = "tmux",
				enabled = true,
			},
			-- Configuración de la ventana
			win = {
				layout = "right", -- layout por defecto
				-- Opciones para layout split (left/right/top/bottom)
				split = {
					width = 50, -- ancho en columnas (por defecto es 80)
					height = 20, -- alto en filas (por defecto es 20)
				},
				-- Opciones para layout float (si prefieres ventana flotante)
				float = {
					width = 0.4, -- 40% del ancho de la pantalla
					height = 0.6, -- 60% del alto de la pantalla
				},
			},
		},
		-- Suprimir notificaciones de Copilot completamente
		copilot = {
			status = {
				level = vim.log.levels.OFF, -- Desactivar todas las notificaciones de status
			},
		},
	},
}
