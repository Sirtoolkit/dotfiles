return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  keys = {
    {
      "<leader>du",
      function()
        require("dapui").toggle({})
      end,
      desc = "Dap UI",
    },
  },
  config = function()
    local dapui = require("dapui")
    dapui.setup({
      icons = { collapsed = "", current_frame = "", expanded = "" },
      layouts = {
        { elements = { "repl" }, size = 10, position = "bottom" },
      },
      floating = { border = "rounded" },
      render = { indent = 2 },
    })
  end,
}
