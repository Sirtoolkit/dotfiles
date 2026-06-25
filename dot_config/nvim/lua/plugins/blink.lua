return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- Some terminals/macOS don't send <C-Space> to Neovim.
        -- Ctrl-x Ctrl-o is terminal-safe and mirrors Vim's built-in omni-complete muscle memory.
        ["<C-x><C-o>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-@>"] = { "show", "show_documentation", "hide_documentation" },
      },
    },
  },
}
