return {
  "ryanmsnyder/toggleterm-manager.nvim",
  lazy = true,
  dependencies = {
    "akinsho/toggleterm.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    local toggleterm_manager = require("toggleterm-manager")
    local actions = toggleterm_manager.actions
    local term_icon = "" -- Icono hardcodeado (antes venía de astroui)

    return {
      titles = {
        prompt = term_icon .. " Terminals",
      },
      results = {
        term_icon = term_icon,
      },
      mappings = {
        n = {
          ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
          ["r"] = { action = actions.rename_term, exit_on_action = false },
          ["d"] = { action = actions.delete_term, exit_on_action = false },
          ["n"] = { action = actions.create_term, exit_on_action = false },
        },
        i = {
          ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
          ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },
          ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },
          ["<C-n>"] = { action = actions.create_term, exit_on_action = false },
        },
      },
    }
  end,
  config = function(_, opts)
    require("toggleterm-manager").setup(opts)
  end,
}
