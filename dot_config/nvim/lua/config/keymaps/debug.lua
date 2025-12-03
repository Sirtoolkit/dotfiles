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
