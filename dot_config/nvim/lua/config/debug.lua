-- Keymaps para Debugging (DAP - Debug Adapter Protocol)

-- Teclas de Función (F-keys)
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Debugger: Start/Continue" })

vim.keymap.set("n", "<F6>", function()
	require("dap").pause()
end, { desc = "Debugger: Pause" })

vim.keymap.set("n", "<F9>", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debugger: Toggle Breakpoint" })

vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "Debugger: Step Over" })

vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "Debugger: Step Into" })

-- Shift+F11 (A veces F23 en algunas terminales)
vim.keymap.set("n", "<S-F11>", function()
	require("dap").step_out()
end, { desc = "Debugger: Step Out" })

-- Shift+F5 (A veces F17)
vim.keymap.set("n", "<S-F5>", function()
	require("dap").terminate()
end, { desc = "Debugger: Stop" })

-- Control+F5 (A veces F29)
vim.keymap.set("n", "<C-F5>", function()
	require("dap").restart_frame()
end, { desc = "Debugger: Restart" })

-- Teclas con Leader (d)
vim.keymap.set("n", "<Leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "󰝥 Toggle Breakpoint" })

vim.keymap.set("n", "<Leader>dB", function()
	require("dap").clear_breakpoints()
end, { desc = "󰝥 Clear Breakpoints" })

vim.keymap.set("n", "<Leader>dc", function()
	require("dap").continue()
end, { desc = "󰆍 Start/Continue" })

vim.keymap.set("n", "<Leader>di", function()
	require("dap").step_into()
end, { desc = "󰆍 Step Into" })

vim.keymap.set("n", "<Leader>do", function()
	require("dap").step_over()
end, { desc = "󰆍 Step Over" })

vim.keymap.set("n", "<Leader>dO", function()
	require("dap").step_out()
end, { desc = "󰆍 Step Out" })

vim.keymap.set("n", "<Leader>dq", function()
	require("dap").close()
end, { desc = "󰆍 Close Session" })

vim.keymap.set("n", "<Leader>dQ", function()
	require("dap").terminate()
end, { desc = "󰆍 Terminate Session" })

vim.keymap.set("n", "<Leader>dp", function()
	require("dap").pause()
end, { desc = "󰆍 Pause" })

vim.keymap.set("n", "<Leader>dr", function()
	require("dap").restart_frame()
end, { desc = "󰆍 Restart" })

vim.keymap.set("n", "<Leader>ds", function()
	require("dap").run_to_cursor()
end, { desc = "󰆍 Run To Cursor" })

-- Funciones Avanzadas (Input condicional)
vim.keymap.set("n", "<Leader>dC", function()
	vim.ui.input({ prompt = "Condition: " }, function(condition)
		if condition then
			require("dap").set_breakpoint(condition)
		end
	end)
end, { desc = "󰝥 Conditional Breakpoint" })

-- Limpiar consola de debug
vim.keymap.set("n", "<leader>dl", function()
	-- Iteramos sobre todos los buffers abiertos
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		-- Buscamos el buffer que sea del tipo 'dap-repl' (REPL estándar)
		-- o 'dapui_console' (Consola específica de nvim-dap-ui)
		local filetype = vim.bo[buf].filetype
		if filetype == "dap-repl" or filetype == "dapui_console" then
			-- Borramos todas las líneas (desde la 0 hasta la última -1)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
		end
	end
	vim.notify("Consola de Debug limpia", vim.log.levels.INFO)
end, { desc = "󰆍 Clear Console" })

-- DAP UI
vim.keymap.set("n", "<Leader>du", function()
	require("dapui").toggle()
end, { desc = "󰆍 Toggle UI" })

-- Configurar 'q' para cerrar la ventana flotante de dap (como hover)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-float",
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
	end,
})

vim.keymap.set("n", "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "󰆍 Hover" })

vim.keymap.set("n", "<Leader>dE", function()
	vim.ui.input({ prompt = "Expression: " }, function(expr)
		if expr then
			require("dapui").eval(expr, { enter = true })
		end
	end)
end, { desc = "󰆍 Evaluate Input" })

-- Evaluar en modo visual
vim.keymap.set("v", "<Leader>dE", function()
	require("dapui").eval()
end, { desc = "󰆍 Evaluate Selection" })
