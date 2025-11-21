return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		opts.options = {
			theme = "auto", -- O "gruvbox" si prefieres forzarlo
			globalstatus = true, -- Una sola barra para toda la ventana
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },
		}
		opts.sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		}
		opts.sections = opts.sections or {}
		opts.sections.lualine_c = opts.sections.lualine_c or {}

		-- Copilot status
		table.insert(opts.sections.lualine_c, {
			function()
				return " "
			end,
			color = function()
				local status = require("sidekick.status").get()
				if status then
					return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
				end
			end,
			cond = function()
				local status = require("sidekick.status")
				return status.get() ~= nil
			end,
		})

		-- CLI session status
		table.insert(opts.sections.lualine_x, 2, {
			function()
				local status = require("sidekick.status").cli()
				return " " .. (#status > 1 and #status or "")
			end,
			cond = function()
				return #require("sidekick.status").cli() > 0
			end,
			color = function()
				return "Special"
			end,
		})
		return opts
	end,
}
