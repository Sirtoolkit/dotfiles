-- ~/.config/nvim/lua/user/opencommit.lua

local M = {}

-- Variable para almacenar nuestra terminal flotante
local oco_term

--- Abre 'oco' en una terminal flotante
function M.run()
  -- Carga el plugin 'toggleterm'
  local Terminal = require("toggleterm.terminal").Terminal

  -- Si la terminal no existe o ya se cerró, crea una nueva
  if not oco_term or not oco_term:is_open() then
    oco_term = Terminal:new({
      --
      -- ESTA ES LA LÍNEA MODIFICADA:
      --
      -- Ejecutamos 'oco' dentro de un shell ('bash -c').
      -- Si 'oco' falla (el '||'), mostramos un mensaje de error y
      -- esperamos a que el usuario presione Enter ('read') antes de cerrar.
      cmd = 'bash -c \'oco || (echo; echo "[Error] oco falló. Asegúrate de tener archivos en stage (git add .)"; echo "Presiona Enter para cerrar."; read)\'',

      -- Inicia en el directorio raíz del repositorio git
      dir = "git_dir",

      -- Queremos que sea una ventana flotante
      direction = "float",
      float_opts = {
        border = "curved", -- Un borde redondeado
        -- 80% del ancho y alto de la pantalla
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
      },

      -- Cierra la ventana automáticamente CUANDO el proceso 'bash' termine
      close_on_exit = true,

      -- Abre la terminal en modo inserción, lista para la interacción
      auto_start = true,
    })
  end

  -- Muestra u oculta la terminal
  oco_term:toggle()
end

return M
