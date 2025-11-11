return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.auto_reload`.
    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<leader>o", function() require("opencode").toggle() end, { desc = "󰭹 Opencode" })

    vim.keymap.set(
      { "n", "x" },
      "<leader>k",
      function() require("opencode").prompt "@this" end,
      { desc = "ask opencode" }
    )
  end,
}
