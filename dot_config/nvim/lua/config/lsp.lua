-- Keymaps para LSP (Language Server Protocol)

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- Git commits con OpenCommit
vim.keymap.set("n", "<leader>gc", function()
	-- Intenta cargar el módulo y ejecutar la función run()
	local ok, opencommit = pcall(require, "user.opencommit")
	if ok then
		opencommit.run()
	else
		vim.notify("No se encontró el módulo lua/user/opencommit.lua", vim.log.levels.ERROR)
	end
end, { desc = "Generar commit (OpenCommit)" })
