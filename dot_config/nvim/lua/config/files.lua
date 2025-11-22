-- Operaciones de archivos y buffers

-- Búsqueda y visualización
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "󰍉 Clear Search" })

-- Operaciones de archivos
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "󰆓 Save" })
vim.keymap.set("n", "<leader>q", "<Cmd>confirm q<CR>", { desc = "󰅖 Quit" })
vim.keymap.set("n", "<leader>Q", "<Cmd>confirm qall<CR>", { desc = "󰅖 Quit All" })
vim.keymap.set("n", "<Leader>n", "<cmd>enew<cr>", { desc = "󰈙 New File" })
vim.keymap.set({ "n", "i", "x" }, "<C-s>", "<cmd>silent! update! | redraw<cr>", { desc = "Force write" })
vim.keymap.set("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })

-- Splits
vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "󰖲 Vertical Split" })
vim.keymap.set("n", "\\", "<cmd>split<cr>", { desc = "󰖲 Horizontal Split" })

-- Gestión de buffers
-- Cierre "inteligente" (Mantiene el split abierto)
vim.keymap.set("n", "<Leader>x", function()
	Snacks.bufdelete()
end, { desc = "󰅖 Close buffer" })

-- Cierre forzado (Ignora cambios sin guardar)
vim.keymap.set("n", "<Leader>X", function()
	-- Obtenemos todos los buffers
	local bufs = vim.api.nvim_list_bufs()
	for _, buf in ipairs(bufs) do
		-- Verificamos que el buffer sea válido y esté listado (para no borrar cosas internas)
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
			Snacks.bufdelete({ buf = buf, force = true })
		end
	end
end, { desc = "󰅖 Close ALL buffers" })

-- Recarga de configuración
vim.keymap.set("n", "<Leader>RR", function()
	for name, _ in pairs(package.loaded) do
		-- Borramos todos los módulos de usuario (user.xxx o plugins.xxx)
		-- Ajusta el patrón 'user' o 'plugins' según tus carpetas
		if name:match("^user") or name:match("^plugins") or name:match("^config") then
			package.loaded[name] = nil
		end
	end

	vim.cmd("source $MYVIMRC")
	vim.notify("Nvim recargado completamente", vim.log.levels.INFO)
end, { desc = "󰒓 Hard Reload Config" })
