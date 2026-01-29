return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        bashls = {
          filetypes = { "sh", "bash" },
          settings = {
            bashIde = {
              shellcheckArguments = { "-e", "SC2034" },
            },
          },
        },
      },
      diagnostics = {
        virtual_text = {
          source = "if_many",
        },
      },
    },
  },
}
