return {
	{
		"akinsho/flutter-tools.nvim",
		lazy = true,
		opts = {
			debugger = {
				enabled = true,
				exception_breakpoints = {},
				evaluate_to_string_in_debug_views = true,
				register_configurations = function(paths)
					require("dap").configurations.dart = {
						{
							type = "dart",
							request = "launch",
							name = "PROD",
							dartSdkPath = paths.dart_bin,
							flutterSdkPath = paths.flutter_bin,
							program = "${workspaceFolder}/lib/main.dart",
							cwd = "${workspaceFolder}",
						},
						{
							type = "dart",
							request = "launch",
							name = "DEV",
							flutterMode = "profile",
							dartSdkPath = paths.dart_bin,
							flutterSdkPath = paths.flutter_bin,
							program = "${workspaceFolder}/lib/main_dev.dart",
							cwd = "${workspaceFolder}",
						},
					}
				end,
			},
			dev_log = {
				enabled = false,
			},
		},
	},
	{
		"AstroNvim/astrolsp",
		---@param opts AstroLSPOpts
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			table.insert(opts.servers, "dartls")

			opts = require("astrocore").extend_tbl(opts, {
				setup_handlers = {
					dartls = function(_, dartls_opts)
						require("flutter-tools").setup({ lsp = dartls_opts })
					end,
				},
				config = {
					dartls = {
						color = {
							enabled = true,
						},
						settings = {
							showTodos = true,
							completeFunctionCalls = true,
							enableSnippets = true,
							updateImportsOnRename = true,
						},
					},
				},
			})
		end,
	},
}
