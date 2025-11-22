-- Keymaps para Flutter

-- Ejecución y Debug
vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<cr>", { desc = "Run App" })
vim.keymap.set("n", "<leader>fd", "<cmd>FlutterDebug<cr>", { desc = "Debug App" })
vim.keymap.set("n", "<leader>fh", "<cmd>FlutterReload<cr>", { desc = "Hot Reload" })
vim.keymap.set("n", "<leader>fH", "<cmd>FlutterRestart<cr>", { desc = "Hot Restart" })
vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<cr>", { desc = "Quit App" })

-- Gestión de Paquetes y Logs
vim.keymap.set("n", "<leader>fp", "<cmd>FlutterPubGet<cr>", { desc = "Get Packages" })
vim.keymap.set("n", "<leader>fb", function()
	-- Intenta cargar el módulo y ejecutar la función run()
	local ok, dart_build_runner = pcall(require, "user.dart_build_runner")
	if ok then
		dart_build_runner.run()
	else
		vim.notify("No se encontró el módulo lua/user/dart_build_runner.lua", vim.log.levels.ERROR)
	end
end, { desc = "Dart Build Runner Build" })
vim.keymap.set("n", "<leader>fP", function()
	-- Intenta cargar el módulo y ejecutar pod install
	local ok, pod_install = pcall(require, "user.pod_install")
	if ok then
		pod_install.install()
	else
		vim.notify("No se encontró el módulo lua/user/pod_install.lua", vim.log.levels.ERROR)
	end
end, { desc = "Pod Install (iOS)" })
vim.keymap.set("n", "<leader>fU", function()
	-- Intenta cargar el módulo y ejecutar pod update
	local ok, pod_install = pcall(require, "user.pod_install")
	if ok then
		pod_install.update()
	else
		vim.notify("No se encontró el módulo lua/user/pod_install.lua", vim.log.levels.ERROR)
	end
end, { desc = "Pod Update (iOS)" })

-- Herramientas
vim.keymap.set("n", "<leader>fo", "<cmd>FlutterOpenDevTools<cr>", { desc = "Open DevTools" })
vim.keymap.set("n", "<leader>fl", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices" })
vim.keymap.set("n", "<leader>fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators" })
