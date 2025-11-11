return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local dapui = require "dapui"

    dapui.setup {
      icons = { collapsed = "", current_frame = "", expanded = "" },
      layouts = {
        { elements = { "repl" }, size = 0.32, position = "bottom" },
      },
      render = { indent = 2 },
    }
  end,
}
