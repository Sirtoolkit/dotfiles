return {
  "echasnovski/mini.icons",
  lazy = true,
  opts = {
    -- Si tienes una variable global para desactivar iconos, la respetamos
    style = vim.g.icons_enabled == false and "ascii" or "glyph",
  },
  init = function()
    -- Esta es la magia: Suplantamos nvim-web-devicons antes de que cargue
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  config = function(_, opts)
    require("mini.icons").setup(opts)
    -- Aseguramos que el mock esté activo
    require("mini.icons").mock_nvim_web_devicons()
  end,
}
