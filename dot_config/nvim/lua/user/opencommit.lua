local M = {}

local oco_term

function M.run()
  local Terminal = require("toggleterm.terminal").Terminal

  if not oco_term or not oco_term:is_open() then
    oco_term = Terminal:new({

      cmd = 'bash -c \'oco || (echo; echo "[Error] oco falló. Asegúrate de tener archivos en stage (git add .)"; echo "Presiona Enter para cerrar."; read)\'',

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

  oco_term:toggle()
end

return M
