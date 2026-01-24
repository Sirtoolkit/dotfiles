local M = {}

local dbb_term

function M.run()
  local Terminal = require("toggleterm.terminal").Terminal

  if not dbb_term or not dbb_term:is_open() then
    dbb_term = Terminal:new({

      cmd = 'zsh -i -c \'dbb || (echo; echo "[Error] dart build_runner build falló."; echo "Presiona Enter para cerrar."; read)\'',

      dir = "git_dir",

      direction = "float",
      float_opts = {
        border = "curved", -- Un borde redondeado

        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
      },

      close_on_exit = true,

      auto_start = true,
    })
  end

  dbb_term:toggle()
end

return M
