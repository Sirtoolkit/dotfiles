-- Navegación entre ventanas (panes)
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

-- Navegación entre Buffers (usando estilo pestañas de navegador)
vim.keymap.set("n", "gt", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "gT", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
