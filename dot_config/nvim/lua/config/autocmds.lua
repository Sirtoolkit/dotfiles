-- Resaltar texto al copiar (Yank Highlight)
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Cerrar buffer "[No Name]" cuando se abre un archivo desde Neo-tree
-- Solo si el buffer está vacío y sin cambios
vim.api.nvim_create_autocmd("BufRead", {
	desc = "Close empty [No Name] buffer when opening file from Neo-tree",
	group = vim.api.nvim_create_augroup("close-noname-on-open", { clear = true }),
	callback = function()
		-- Esperar un momento para que el buffer se cargue completamente
		vim.schedule(function()
			-- Buscar el buffer "[No Name]" (buffer sin nombre)
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local buf_name = vim.api.nvim_buf_get_name(buf)
				local buf_option = vim.bo[buf]
				
				-- Verificar si es un buffer "[No Name]" (sin nombre y listado)
				if buf_name == "" and buf_option.buflisted and vim.api.nvim_buf_is_valid(buf) then
					-- Verificar si está vacío y sin cambios
					local line_count = vim.api.nvim_buf_line_count(buf)
					local is_modified = buf_option.modified
					
					-- Si está vacío (solo tiene una línea vacía) y sin cambios, cerrarlo
					if line_count <= 1 and not is_modified then
						local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
						if first_line == "" then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end
				end
			end
		end)
	end,
})

-- Cerrar cualquier buffer de Netrw que se intente abrir
vim.api.nvim_create_autocmd("FileType", {
	desc = "Close Netrw buffers",
	group = vim.api.nvim_create_augroup("close-netrw", { clear = true }),
	pattern = "netrw",
	callback = function()
		vim.api.nvim_buf_delete(0, { force = true })
	end,
})
