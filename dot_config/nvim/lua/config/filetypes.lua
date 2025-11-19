-- Reconocer archivos .blade.php correctamente
vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})
