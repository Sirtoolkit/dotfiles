---@type MappingsSpec
return {
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = {
			mappings = {
				-- first key is the mode
				n = {
					-- Prefijo <leader>F para Flutter
					["<leader>F"] = { name = "󰐚 Flutter" },

					-- Ejecución y Recarga
					["<leader>Fr"] = { "<cmd>FlutterDebug<cr>", desc = "Run App" },
					["<leader>Fh"] = { "<cmd>FlutterReload<cr>", desc = "Hot Reload" },
					["<leader>FH"] = { "<cmd>FlutterRestart<cr>", desc = "Hot Restart" },
					["<leader>Fq"] = { "<cmd>FlutterQuit<cr>", desc = "Quit App" },
					["<leader>Fp"] = { "<cmd>FlutterPubGet<cr>", desc = "Get Packages" },

					-- Depuración (DAP)
					["<leader>Fd"] = {
						function()
							require("dap").continue()
						end,
						desc = "DAP: Start/Continue",
					},
					["<leader>FD"] = {
						function()
							require("dap").disconnect()
						end,
						desc = "DAP: Disconnect",
					},
					["<leader>Ft"] = {
						function()
							require("dap").toggle_breakpoint()
						end,
						desc = "DAP: Toggle Breakpoint",
					},
					["<leader>Fb"] = {
						function()
							require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
						end,
						desc = "DAP: Set Conditional Breakpoint",
					},
					["<leader>Fso"] = {
						function()
							require("dap").step_over()
						end,
						desc = "DAP: Step Over",
					},
					["<leader>Fsi"] = {
						function()
							require("dap").step_into()
						end,
						desc = "DAP: Step Into",
					},
					["<leader>Fsu"] = {
						function()
							require("dap").step_out()
						end,
						desc = "DAP: Step Out",
					},
					-- ["<leader>Frr"] = { function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },

					-- Utilidades
					["<leader>Fo"] = { "<cmd>FlutterOpenDevTools<cr>", desc = "Open DevTools" },
					["<leader>Fl"] = { "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
					["<leader>Fe"] = { "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },
					["<leader>Fc"] = { "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy Profiler URL" },

					--  ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
				},
				t = {},
			},
		},
	},
	{
		"AstroNvim/astrolsp",
		---@type AstroLSPOpts
		opts = {
			mappings = {
				n = {
					K = {
						function()
							vim.lsp.buf.hover()
						end,
						desc = "Hover symbol details",
					},
					gD = {
						function()
							vim.lsp.buf.declaration()
						end,
						desc = "Declaration of current symbol",
						cond = "textDocument/declaration",
					},
				},
			},
		},
	},
}
