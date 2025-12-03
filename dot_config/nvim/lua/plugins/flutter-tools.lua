return {
  "akinsho/flutter-tools.nvim",
  lazy = false, -- Cargar al inicio para que detecte proyectos Flutter rápido
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- Opcional: UI bonita para selectores
  },
  -- 2. Configuración principal
  opts = {
    ui = {
      border = "rounded",
    },
    dev_log = {
      enabled = false,
    },
    -- 3. Configuración del Debugger (DAP)
    debugger = {
      enabled = true,
      exception_breakpoints = {},
      evaluate_to_string_in_debug_views = true,
      register_configurations = function(paths)
        local dap = require("dap")

        -- Tus configuraciones personalizadas de PROD y DEV
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
            flutterMode = "profile", -- Ojo: profile no soporta debug breakpoints, solo ejecución
            dartSdkPath = paths.dart_bin,
            flutterSdkPath = paths.flutter_bin,
            program = "${workspaceFolder}/lib/main_dev.dart",
            cwd = "${workspaceFolder}",
          },
        }
      end,
    },
    -- 4. Configuración LSP (Reemplaza a astrolsp)
    lsp = {
      color = {
        enabled = true,
      },
      -- Settings que se pasan a dartls
      settings = {
        showTodos = true,
        completeFunctionCalls = true,
        enableSnippets = true,
        updateImportsOnRename = true, -- Muy útil al mover archivos
        dart = {
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/.pub-cache"),
            vim.fn.expand("/opt/flutter/"),
          },
        },
      },
      -- Capabilities para autocompletado (nvim-cmp / blink)
      -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
    },
  },
}
