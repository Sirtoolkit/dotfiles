vim.keymap.set("", "<tab>", function()
	-- if there is a next edit, jump to it, otherwise apply it if any
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>" -- fallback to normal tab
	end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle" })

vim.keymap.set("", "<leader>aa", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })

vim.keymap.set("", "<leader>as", function()
	require("sidekick.cli").select()
end, { desc = "Select CLI" })

vim.keymap.set("", "<leader>ad", function()
	require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })

vim.keymap.set({ "x", "n" }, "<leader>at", function()
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

vim.keymap.set("", "<leader>af", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

vim.keymap.set("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

vim.keymap.set({ "n", "x" }, "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

vim.keymap.set("", "<leader>ao", function()
	require("sidekick.cli").toggle({ name = "opencode", focus = true })
end, { desc = "Sidekick Toggle Opencode" })

vim.keymap.set("", "<leader>ag", function()
	require("sidekick.cli").toggle({ name = "gemini", focus = true })
end, { desc = "Sidekick Toggle Gemini" })

vim.keymap.set("", "<leader>ac", function()
	require("sidekick.cli").toggle({ name = "cursor", focus = true })
end, { desc = "Sidekick Toggle Cursor" })

-- Variable para rastrear el estado (asumimos que inicia encendido)
local copilot_on = true

vim.api.nvim_create_user_command("CopilotToggle", function()
	if copilot_on then
		vim.cmd("Copilot disable")
		print("Copilot Desactivado")
	else
		vim.cmd("Copilot enable")
		print("Copilot Activado")
	end
	copilot_on = not copilot_on
end, { nargs = 0 })

-- Mapeo de tecla: <Leader> + ct (Copilot Toggle)
vim.keymap.set("n", "<leader>ct", ":CopilotToggle<CR>", { noremap = true, silent = true })
