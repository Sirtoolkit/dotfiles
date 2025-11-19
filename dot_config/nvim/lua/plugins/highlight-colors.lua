return {
	"brenoprata10/nvim-highlight-colors",
	-- Cargamos el plugin al abrir archivos o al entrar en modo insertar
	event = { "BufReadPre", "BufNewFile", "InsertEnter" },
	cmd = "HighlightColors",
	opts = {
		enable_named_colors = false,
		render = "virtual", -- Asegura que se use el símbolo virtual (si solo querías el icono)
		virtual_symbol = "󱓻",

		-- Reemplazo nativo de astrocore.buffer.is_large y is_valid
		exclude_buffer = function(bufnr)
			-- 1. Verificar si el buffer es válido
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return true
			end

			-- 2. Lógica de "Archivo Grande" (Large File) manual
			local byte_size = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
			-- Si pesa más de 1MB (1024*1024) o tiene más de 100k líneas, lo excluimos
			if byte_size > 1024 * 1024 then
				return true
			end

			return false
		end,
	},
}
