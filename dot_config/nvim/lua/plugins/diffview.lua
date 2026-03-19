return {
  "tanvirtin/vgit.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  event = "VimEnter",
  config = function()
    require("vgit").setup({
      keymaps = {
        ["n <C-k>"] = function()
          require("vgit").hunk_up()
        end,
        {
          mode = "n",
          key = "<C-j>",
          handler = "hunk_down",
          desc = "Go down in the direction of the hunk",
        },
      },
    })
  end,
}
