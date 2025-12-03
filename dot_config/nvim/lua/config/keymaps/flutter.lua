-- Keymaps para Flutter

-- Ejecución y Debug
vim.keymap.set("n", "<leader>Fr", "<cmd>FlutterRun<cr>", { desc = "Run App" })
vim.keymap.set("n", "<leader>Fd", "<cmd>FlutterDebug<cr>", { desc = "Debug App" })
vim.keymap.set("n", "<leader>Fh", "<cmd>FlutterReload<cr>", { desc = "Hot Reload" })
vim.keymap.set("n", "<leader>FH", "<cmd>FlutterRestart<cr>", { desc = "Hot Restart" })
vim.keymap.set("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Quit App" })

-- Gestión de Paquetes y Logs
vim.keymap.set("n", "<leader>Fp", "<cmd>FlutterPubGet<cr>", { desc = "Get Packages" })
vim.keymap.set("n", "<leader>Fb", function()
  -- Intenta cargar el módulo y ejecutar la función run()
  local ok, dart_build_runner = pcall(require, "user.dart_build_runner")
  if ok then
    dart_build_runner.run()
  else
    vim.notify("No se encontró el módulo lua/user/dart_build_runner.lua", vim.log.levels.ERROR)
  end
end, { desc = "Build Runner" })
vim.keymap.set("n", "<leader>FP", function()
  -- Intenta cargar el módulo y ejecutar pod install
  local ok, pod_install = pcall(require, "user.pod_install")
  if ok then
    pod_install.install()
  else
    vim.notify("No se encontró el módulo lua/user/pod_install.lua", vim.log.levels.ERROR)
  end
end, { desc = "Pod Install" })
vim.keymap.set("n", "<leader>FU", function()
  -- Intenta cargar el módulo y ejecutar pod update
  local ok, pod_install = pcall(require, "user.pod_install")
  if ok then
    pod_install.update()
  else
    vim.notify("No se encontró el módulo lua/user/pod_install.lua", vim.log.levels.ERROR)
  end
end, { desc = "Pod Update" })

-- Herramientas
vim.keymap.set("n", "<leader>Fo", "<cmd>FlutterOpenDevTools<cr>", { desc = "DevTools" })
vim.keymap.set("n", "<leader>Fl", "<cmd>FlutterDevices<cr>", { desc = "Devices" })
vim.keymap.set("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>", { desc = "Emulators" })
