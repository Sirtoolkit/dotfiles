-- Keymaps para Flutter

-- Ejecución y Debug
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
