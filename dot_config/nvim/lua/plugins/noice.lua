return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		routes = {
			-- Ocultar notificaciones de Copilot completamente
			{
				filter = {
					event = "msg_show",
					find = "Copilot",
				},
				opts = { skip = true },
			},
			-- Ocultar mensajes que contengan wincmd (por si acaso)
			{
				filter = {
					event = "msg_show",
					find = "wincmd",
				},
				opts = { skip = true },
			},
			-- Ocultar advertencias de Neo-tree sobre mapeos inválidos
			{
				filter = {
					event = "msg_show",
					find = "Neo-tree.*Invalid mapping",
				},
				opts = { skip = true },
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
