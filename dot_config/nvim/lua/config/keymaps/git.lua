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

vim.keymap.set("n", "<leader>gw", function()
  local ok, worktreeSwitch = pcall(require, "user.worktree_switch")
  if ok then
    worktreeSwitch.run()
  else
    vim.notify("No se encontró el módulo lua/user/worktree_switch.lua", vim.log.levels.ERROR)
  end
end, { desc = "󰊢 Git Worktree Switch" })

-- Desactivar atajos de git que no se usan y reemplazarlos con vgit conflict resolution
-- Se usa defer_fn para asegurar que se ejecute después de que LazyVim cargue sus keymaps
vim.defer_fn(function()
  -- Eliminar keymaps de LazyVim primero
  pcall(vim.keymap.del, "n", "<leader>gb")
  pcall(vim.keymap.del, "n", "<leader>gi")

  -- Definir nuevos keymaps de vgit después
  vim.keymap.set("n", "<leader>gb", function()
    require("vgit").buffer_conflict_accept_both()
  end, { desc = "󰊢 Accept Both (Conflict)" })

  vim.keymap.set("n", "<leader>go", function()
    require("vgit").buffer_conflict_accept_current()
  end, { desc = "󰊢 Accept Current (Conflict)" })

  vim.keymap.set("n", "<leader>gi", function()
    require("vgit").buffer_conflict_accept_incoming()
  end, { desc = "󰊢 Accept Incoming (Conflict)" })
end, 100)
