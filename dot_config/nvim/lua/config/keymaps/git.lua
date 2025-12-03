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
