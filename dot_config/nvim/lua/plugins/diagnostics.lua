---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      diagnostics = true,
    },
    diagnostics = {
      virtual_text = true,
      virtual_lines = false, -- Neovim v0.11+ only
      update_in_insert = false,
      underline = true,
      severity_sort = true,
    },
  },
}
