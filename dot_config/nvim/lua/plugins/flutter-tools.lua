return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },

  opts = {
    ui = {
      border = "rounded",
    },
    dev_log = {
      enabled = false,
    },

    debugger = {
      enabled = true,
      exception_breakpoints = {},
      evaluate_to_string_in_debug_views = true,
      register_configurations = function(paths)
        local dap = require("dap")

        dap.configurations.dart = {
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

    lsp = {
      color = {
        enabled = true,
      },

      settings = {
        showTodos = true,
        completeFunctionCalls = true,
        enableSnippets = true,
        updateImportsOnRename = true,
        dart = {
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/.pub-cache"),
            vim.fn.expand("/opt/flutter/"),
          },
        },
      },
    },
  },
}
