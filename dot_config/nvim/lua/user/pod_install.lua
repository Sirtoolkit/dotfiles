local M = {}

local pod_term

function M.install()
  local Terminal = require("toggleterm.terminal").Terminal

  if not pod_term or not pod_term:is_open() then
    pod_term = Terminal:new({

      cmd = 'fish -c \'cd ios; and pod install; or begin; echo; echo "[Error] pod install falló."; echo "Presiona Enter para cerrar."; read; end\'',

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
  else
    pod_term.cmd =
      'fish -c \'cd ios; and pod install; or begin; echo; echo "[Error] pod install falló."; echo "Presiona Enter para cerrar."; read; end\''
  end

  pod_term:toggle()
end

function M.update()
  local Terminal = require("toggleterm.terminal").Terminal

  if not pod_term or not pod_term:is_open() then
    pod_term = Terminal:new({

      cmd = 'fish -c \'cd ios; and pod update; or begin; echo; echo "[Error] pod update falló."; echo "Presiona Enter para cerrar."; read; end\'',

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
  else
    pod_term.cmd =
      'fish -c \'cd ios; and pod update; or begin; echo; echo "[Error] pod update falló."; echo "Presiona Enter para cerrar."; read; end\''
  end

  pod_term:toggle()
end

return M
