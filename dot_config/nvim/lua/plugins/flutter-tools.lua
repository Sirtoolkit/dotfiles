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
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- Prefijo <leader>F para Flutter
          ["<leader>F"] = { name = " Flutter" },

          -- Ejecución y Recarga
          ["<leader>Fr"] = { "<cmd>FlutterDebug<cr>", desc = "Run App" },
          ["<leader>Fh"] = { "<cmd>FlutterReload<cr>", desc = "Hot Reload" },
          ["<leader>FH"] = { "<cmd>FlutterRestart<cr>", desc = "Hot Restart" },
          ["<leader>Fq"] = { "<cmd>FlutterQuit<cr>", desc = "Quit App" },
          ["<leader>Fp"] = { "<cmd>FlutterPubGet<cr>", desc = "Get Packages" },
          ["<leader>Fc"] = { "<cmd>FlutterLogClear<cr>", desc = "Clears the log buffer" },

          -- Utilidades
          ["<leader>Fo"] = { "<cmd>FlutterOpenDevTools<cr>", desc = "Open DevTools" },
          ["<leader>Fl"] = { "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
          ["<leader>Fe"] = { "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },
        },
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
          dartls = function(_, dartls_opts) require("flutter-tools").setup { lsp = dartls_opts } end,
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
