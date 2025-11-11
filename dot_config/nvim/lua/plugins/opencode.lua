---@type LazySpec
return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      auto_fallback_to_embedded = false,
    },
    keys = {
      {
        "<leader>Oa",
        function() require("opencode").ask() end,
        mode = "n",
        desc = "Ask opencode",
      },
      {
        "<leader>Oa",
        function() require("opencode").ask "@selection: " end,
        mode = "v",
        desc = "Ask opencode",
      },
      {
        "<leader>Op",
        function() require("opencode").select_prompt() end,
        mode = { "n", "v" },
        desc = "Execute opencode action…",
      },
    },
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = { enabled = false },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },
}
