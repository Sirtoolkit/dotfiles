---@type LazySpec
return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    dap.adapters.dart = {
      type = "executable",
      command = "dart",
      args = { "debug_adapter" },
    }

    dap.configurations.dart = {
      {
        name = "Launch Current File",
        type = "dart",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
    }
  end,
}
