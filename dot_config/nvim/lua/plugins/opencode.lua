return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<leader>o"] = { name = "󰭹 OpenCode" },
            ["<leader>og"] = { function() require("opencode").toggle() end, desc = "OpenCode Start" },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    -- Required for `opts.auto_reload`.
    vim.o.autoread = true
  end,
}
