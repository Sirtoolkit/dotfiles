-- Keymaps para LSP (Language Server Protocol)

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "󰒋 Hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "󰒋 Go to Definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "󰈇 References" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "󰌶 Code Action" })
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "󰒋 Rename" })
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
end, { desc = "󰊢 Git Commit" })
