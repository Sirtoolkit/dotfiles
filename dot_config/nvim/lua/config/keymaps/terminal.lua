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
