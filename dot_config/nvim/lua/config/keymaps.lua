-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Navegación entre ventanas desde el Modo Terminal
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<Cmd>confirm q<CR>")
vim.keymap.set("n", "<leader>Q", "<Cmd>confirm qall<CR>")

vim.keymap.set("n", "<Leader>n", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set({ "n", "i", "x" }, "<C-s>", "<cmd>silent! update! | redraw<cr>", { desc = "Force write" })
vim.keymap.set("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })
vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>uz", "<Cmd>HighlightColors Toggle<CR>", { desc = "Toggle color highlight" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

vim.keymap.set("n", "<leader>gc", function()
	-- Intenta cargar el módulo y ejecutar la función run()
	local ok, opencommit = pcall(require, "user.opencommit")
	if ok then
		opencommit.run()
	else
		vim.notify("No se encontró el módulo lua/user/opencommit.lua", vim.log.levels.ERROR)
	end
end, { desc = "Generar commit (OpenCommit)" })

vim.keymap.set("n", "<Leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm float" })
vim.keymap.set(
	"n",
	"<Leader>th",
	"<cmd>ToggleTerm size=10 direction=horizontal<cr>",
	{ desc = "ToggleTerm horizontal split" }
)
vim.keymap.set(
	"n",
	"<Leader>tv",
	"<cmd>ToggleTerm size=80 direction=vertical<cr>",
	{ desc = "ToggleTerm vertical split" }
)
vim.keymap.set("n", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toogle terminal" })
vim.keymap.set("n", "<Leader>ts", "<cmd>Telescope toggleterm_manager<cr>", { desc = "Search Toggleterms" })
vim.keymap.set("n", "<Leader>td", "<cmd>LazyDocker<cr>", { desc = "Toggle LazyDocker" })

vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<cr>", { desc = "Run App" })
vim.keymap.set("n", "<leader>fd", "<cmd>FlutterDebug<cr>", { desc = "Debug App" })
vim.keymap.set("n", "<leader>fh", "<cmd>FlutterReload<cr>", { desc = "Hot Reload" })
vim.keymap.set("n", "<leader>fH", "<cmd>FlutterRestart<cr>", { desc = "Hot Restart" })
vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<cr>", { desc = "Quit App" })

-- Gestión de Paquetes y Logs
vim.keymap.set("n", "<leader>fp", "<cmd>FlutterPubGet<cr>", { desc = "Get Packages" })

-- Herramientas
vim.keymap.set("n", "<leader>fo", "<cmd>FlutterOpenDevTools<cr>", { desc = "Open DevTools" })
vim.keymap.set("n", "<leader>fl", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices" })
vim.keymap.set("n", "<leader>fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators" })

vim.keymap.set({ "n", "x" }, "<leader>o", function()
	require("opencode").toggle()
end, { desc = "󰭹 Opencode" })

vim.keymap.set({ "n", "x" }, "<leader>k", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "󰭹 Opencode Select" })

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
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dB", function()
	require("dap").clear_breakpoints()
end, { desc = "Clear Breakpoints" })
vim.keymap.set("n", "<Leader>dc", function()
	require("dap").continue()
end, { desc = "Start/Continue" })
vim.keymap.set("n", "<Leader>di", function()
	require("dap").step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<Leader>do", function()
	require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<Leader>dO", function()
	require("dap").step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "<Leader>dq", function()
	require("dap").close()
end, { desc = "Close Session" })
vim.keymap.set("n", "<Leader>dQ", function()
	require("dap").terminate()
end, { desc = "Terminate Session" })
vim.keymap.set("n", "<Leader>dp", function()
	require("dap").pause()
end, { desc = "Pause" })
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").restart_frame()
end, { desc = "Restart" })
vim.keymap.set("n", "<Leader>ds", function()
	require("dap").run_to_cursor()
end, { desc = "Run To Cursor" })

-- Funciones Avanzadas (Input condicional)
vim.keymap.set("n", "<Leader>dC", function()
	vim.ui.input({ prompt = "Condition: " }, function(condition)
		if condition then
			require("dap").set_breakpoint(condition)
		end
	end)
end, { desc = "Conditional Breakpoint" })

vim.keymap.set("n", "<leader>dcl", function()
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
end, { desc = "Clear Debug Console" })

vim.keymap.set("n", "<Leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle Debugger UI" })

vim.keymap.set("n", "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "Debugger Hover" })

vim.keymap.set("n", "<Leader>dE", function()
	vim.ui.input({ prompt = "Expression: " }, function(expr)
		if expr then
			require("dapui").eval(expr, { enter = true })
		end
	end)
end, { desc = "Evaluate Input" })

-- Evaluar en modo visual
vim.keymap.set("v", "<Leader>dE", function()
	require("dapui").eval()
end, { desc = "Evaluate Selection" })

-- Cierre "inteligente" (Mantiene el split abierto)
vim.keymap.set("n", "<Leader>x", function()
	Snacks.bufdelete()
end, { desc = "Close buffer" })

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
end, { desc = "Close ALL buffers" })

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
end, { desc = "Hard Reload Config" })

-- 1. <Leader>/ en Modo Normal: Comenta/Descomenta la línea actual
vim.keymap.set("n", "<Leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment line" })

-- 2. <Leader>/ en Modo Visual: Comenta/Descomenta la selección
vim.keymap.set(
	"v",
	"<Leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
	{ desc = "Toggle comment selection" }
)

-- Navegación entre Buffers (usando estilo pestañas de navegador)
vim.keymap.set("n", "gt", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "gT", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
