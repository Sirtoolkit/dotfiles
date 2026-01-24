return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    size = 10,
    open_mapping = [[<F7>]],
    shading_factor = 2,
    float_opts = {
      border = "rounded",
    },
    highlights = {
      Normal = { link = "Normal" },
      NormalNC = { link = "NormalNC" },
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "FloatBorder" },
    },

    on_create = function(_)
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.signcolumn = "no"
    end,
  },
}
