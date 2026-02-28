return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(v)
        return not vim.tbl_contains({ "copilot" }, v.name)
      end, opts.sources)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
  },
}
