return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	lazy = false, -- <--- ESTO ES CLAVE: Le dice "Cárgate YA, no esperes"
	opts = {
		check_ts = true, -- Habilitar integración con Treesitter
		-- Configuración de Fast Wrap (Alt+e para envolver código)
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0,
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	},
	config = function(_, opts)
		local npairs = require("nvim-autopairs")
		npairs.setup(opts)

		-- 1. Integración con nvim-cmp (CRUCIAL para que ponga () al autocompletar)
		local cmp_ok, cmp = pcall(require, "cmp")
		if cmp_ok then
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end

		vim.g.autopairs_enabled = true
	end,
}
