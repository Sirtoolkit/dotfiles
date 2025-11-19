-- Keymaps para comentarios (Comment.nvim)

-- <Leader>/ en Modo Normal: Comenta/Descomenta la línea actual
vim.keymap.set("n", "<Leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment line" })

-- <Leader>/ en Modo Visual: Comenta/Descomenta la selección
vim.keymap.set(
	"v",
	"<Leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
	{ desc = "Toggle comment selection" }
)
