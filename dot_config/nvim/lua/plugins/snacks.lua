return {
	"folke/snacks.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = [[
                                              
       ████ ██████           █████      ██
      ███████████             █████ 
      █████████ ███████████████████ ███   ███████████
     █████████  ███    █████████████ █████ ██████████████
    █████████ ██████████ █████████ █████ █████ ████ █████
  ███████████ ███    ███ █████████ █████ █████ ████ █████
 ██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
			},
		},
		indent = { enabled = true },
		input = { enabled = true },
		git = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>go",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git browse (open)",
		},
		{
			"<C-p>",
			function()
				Snacks.picker.files({ hidden = true, ignored = true })
			end,
			desc = "Find Files",
		},
		{
			"<leader>sg",
			function()
				require("snacks").picker.grep({ hidden = true, ignored = true })
			end,
			desc = "Grep Files",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Grep Files",
		},
		{
			"<leader>ld",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Search diagnostics",
		},
	},
}
