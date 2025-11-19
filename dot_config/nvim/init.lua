-- init.lua

-- 1. Cargar Opciones Base (vim.opt)
require("config.options")

-- 2. Cargar Atajos Globales (vim.keymap)
require("config.keymaps")
require("config.autocmds")

-- 3. Cargar el gestor de plugins (Lazy)
-- Nota: Lazy cargará los archivos de lua/plugins/
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
