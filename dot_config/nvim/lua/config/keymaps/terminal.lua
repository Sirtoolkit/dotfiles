-- Keymaps para Terminal y ToggleTerm

vim.keymap.set("n", "<Leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "󰆍 ToggleTerm float" })
vim.keymap.set(
  "n",
  "<Leader>th",
  "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
  { desc = "󰆍 ToggleTerm horizontal split" }
)
vim.keymap.set(
  "n",
  "<Leader>tv",
  "<cmd>ToggleTerm size=80 direction=vertical<cr>",
  { desc = "󰆍 ToggleTerm vertical split" }
)
vim.keymap.set("n", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "󰆍 Toggle terminal" })
vim.keymap.set("n", "<Leader>ts", "<cmd>Telescope toggleterm_manager<cr>", { desc = "󰆍 Search Terminals" })

-- Navegación desde terminal usando vim motions
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Mover a ventana izquierda" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Mover a ventana abajo" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Mover a ventana arriba" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Mover a ventana derecha" })
