return {
  "akinsho/flutter-tools.nvim",
  ft = { "dart" },
  cmd = {
    "FlutterRun",
    "FlutterDebug",
    "FlutterReload",
    "FlutterRestart",
    "FlutterQuit",
    "FlutterPubGet",
    "FlutterOpenDevTools",
    "FlutterDevices",
    "FlutterEmulators",
  },
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
      autostart = false,
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
            vim.fn.getcwd() .. "/.dart_tool",
            vim.fn.getcwd() .. "/build",
            vim.fn.getcwd() .. "/ios/Pods",
            vim.fn.getcwd() .. "/android/.gradle",
          },
        },
      },
    },
  },

  config = function(_, opts)
    require("flutter-tools").setup(opts)
  end,
}
