return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	lazy = true, -- Se carga solo cuando Comment.nvim lo llama
	opts = {
		enable_autocmd = false, -- Desactivamos esto por rendimiento (lo invocamos manualmente)
	},
	config = function(_, opts)
		require("ts_context_commentstring").setup(opts)
	end,
}
