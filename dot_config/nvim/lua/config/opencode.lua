-- Keymaps para OpenCode

vim.keymap.set({ "n", "x" }, "<leader>o", function()
	require("opencode").toggle()
end, { desc = "󰭹 Opencode" })

vim.keymap.set({ "n", "x" }, "<leader>k", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "󰭹 Opencode Select" })
