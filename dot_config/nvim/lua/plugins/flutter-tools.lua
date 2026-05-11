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

    dev_tools = {
      autostart = true,
      auto_open_browser = false,
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

  config = function(_, opts)
    local flutter_tools = require("flutter-tools")
    flutter_tools.setup(opts)

    -- flutter-tools registers commands lazily after entering Dart/pubspec buffers.
    -- Register them at startup so global Flutter keymaps work from dashboards too.
    flutter_tools.setup_project({})
  end,
}
