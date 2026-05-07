return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },

  opts = {
    flutter_lookup_cmd = vim.fn.expand("~/.config/nvim/bin/flutter-sdk-path"),

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
        require("user.flutter_launch_configs").register(paths)
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
