return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>dl",
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local filetype = vim.bo[buf].filetype
          if filetype == "dap-repl" or filetype == "dapui_console" then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
          end
        end
        vim.notify("Consola de Debug limpia", vim.log.levels.INFO)
      end,
      desc = "Clear Console",
    },
  },
}
