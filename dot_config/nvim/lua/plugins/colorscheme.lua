return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- Asegura que cargue primero para evitar parpadeos
	opts = {
		contrast = "hard",
		italic = {
			strings = true,
			comments = true,
			folds = true,
			operations = false,
		},
	},
	config = function(_, opts)
		require("gruvbox").setup(opts)
		vim.cmd.colorscheme("gruvbox")
	end,
}

-- return {
-- 	"catppuccin/nvim",
-- 	priority = 1000, -- Ensure it loads first
-- 	opts = {
-- 		flavour = "mocha", -- latte, frappe, macchiato, mocha
-- 	},
-- 	config = function(_, opts)
-- 		require("catppuccin").setup(opts)
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	priority = 1000, -- Ensure it loads first
-- 	opts = {
-- 		theme = "dragon",
-- 	},
-- 	config = function(_, opts)
-- 		require("kanagawa").setup(opts)
-- 		vim.cmd.colorscheme("kanagawa")
-- 	end,
-- }

-- return {
-- 	"neanias/everforest-nvim",
-- 	priority = 1000, -- Ensure it loads first
-- 	version = false,
-- 	lazy = false,
-- 	opts = {
-- 		options = {
-- 			theme = "everforest", -- Can also be "auto" to detect automatically.
-- 		},
-- 	},
-- 	config = function(_, opts)
-- 		require("everforest").setup(opts)
-- 		vim.cmd.colorscheme("everforest")
-- 	end,
-- }

-- return {
-- 	"olimorris/onedarkpro.nvim",
-- 	priority = 1000, -- Ensure it loads first
-- 	opts = {},
-- 	config = function(_, opts)
-- 		-- local theme = "onedarkpro"
-- 		-- require(theme).setup(opts)
-- 		vim.cmd.colorscheme("onedark") -- onedark, onelight, onedark_vivid, onedark_dark, vaporwave
-- 	end,
-- }
