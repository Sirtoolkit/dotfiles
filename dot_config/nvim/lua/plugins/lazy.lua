return {
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.prisma" },
  { import = "lazyvim.plugins.extras.lang.php" },
  { import = "lazyvim.plugins.extras.lang.dotnet" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.kotlin" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.astro" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.vue" },

  { import = "lazyvim.plugins.extras.editor.dial" },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },

  { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
  { import = "lazyvim.plugins.extras.util.dot" },
  { import = "lazyvim.plugins.extras.util.gh" },

  { import = "lazyvim.plugins.extras.lsp.none-ls" },

  { import = "lazyvim.plugins.extras.dap.core" },

  { import = "lazyvim.plugins.extras.ai.sidekick" },
  { import = "lazyvim.plugins.extras.ai.copilot" },

  { import = "lazyvim.plugins.extras.ui.edgy" },

  { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
  { import = "lazyvim.plugins.extras.coding.yanky" },

  { "projekt0n/github-nvim-theme" },
  { "catppuccin/nvim" },
  { "rebelot/kanagawa.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true,
      contrast = "hard",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd("colorscheme gruvbox")
      -- Configurar fondo de ventanas flotantes y terminal para coincidir con el tema
      local colors = require("gruvbox").palette
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.dark0 })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.dark0, fg = colors.gray })
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.dark0 })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.dark0, fg = colors.gray })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.dark1, fg = colors.light1 })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.dark0, fg = colors.gray })
      vim.api.nvim_set_hl(0, "TabLine", { bg = colors.dark0, fg = colors.gray })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.dark0 })
      vim.api.nvim_set_hl(0, "WinBar", { bg = colors.dark0 })
      vim.api.nvim_set_hl(0, "WinBarNC", { bg = colors.dark0 })
    end,
  },
}
