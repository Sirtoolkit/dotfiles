return {
  "tanvirtin/vgit.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>gk",
      function()
        require("vgit").hunk_up()
      end,
      desc = "VGit hunk up",
    },
    {
      "<leader>gj",
      function()
        require("vgit").hunk_down()
      end,
      desc = "VGit hunk down",
    },
  },
  opts = {},
}
