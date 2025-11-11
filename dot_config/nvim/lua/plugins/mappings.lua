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
					["<leader>Fc"] = { "<cmd>FlutterLogClear<cr>", desc = "Clears the log buffer" },

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

					-- Utilidades
					["<leader>Fo"] = { "<cmd>FlutterOpenDevTools<cr>", desc = "Open DevTools" },
					["<leader>Fl"] = { "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
					["<leader>Fe"] = { "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },

					gt = {
						function()
							require("astrocore.buffer").nav(vim.v.count1)
						end,
						desc = "Next buffer",
					},
					gT = {
						function()
							require("astrocore.buffer").nav(-vim.v.count1)
						end,
						desc = "Previous buffer",
					},
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
					gd = {
						function()
							vim.lsp.buf.definition()
						end,
						desc = "Jump to definition",
					},
				},
			},
		},
	},
}
