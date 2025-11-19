return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				ensure_installed = {
					"bash",
					"ruby",
					"html",
					"css",
					"scss",
					"javascript",
					"typescript",
					"json",
					"lua",
					"dart",
					"vim",
					"vimdoc",
					"php",
					"php_only",
					"blade",
					"yaml",
					"tsx",
					"java",
					"kotlin",
					"dockerfile",
					"terraform",
					"hcl",
					"xml",
					"prisma",
					"swift",
				},
				highlight = { enable = true },
				indent = { enable = false },
			})
		end,
	},
	-- dependencies = {
	--   {
	--     "EmranMR/tree-sitter-blade",
	--     config = function()
	--       require("tree-sitter-blade").setup({})
	--       local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	--       parser_config.blade = {
	--         install_info = {
	--           url = "https://github.com/EmranMR/tree-sitter-blade",
	--           files = { "src/parser.c" },
	--           branch = "main",
	--         },
	--         filetype = "blade",
	--       }
	--     end,
	--   },
	-- },
}
