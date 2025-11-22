-- ~/.config/nvim/lua/user/dart_build_runner.lua

local M = {}

-- Variable para almacenar nuestra terminal flotante
local dbb_term

--- Ejecuta 'dbb' (dart build_runner build) en una terminal flotante
function M.run()
	-- Carga el plugin 'toggleterm'
	local Terminal = require("toggleterm.terminal").Terminal

	-- Si la terminal no existe o ya se cerró, crea una nueva
	if not dbb_term or not dbb_term:is_open() then
		dbb_term = Terminal:new({
			--
			-- ESTA ES LA LÍNEA MODIFICADA:
			--
			-- Ejecutamos 'dbb' dentro de un shell interactivo de zsh para cargar aliases.
			-- Si 'dbb' falla (el '||'), mostramos un mensaje de error y
			-- esperamos a que el usuario presione Enter ('read') antes de cerrar.
			cmd = 'zsh -i -c \'dbb || (echo; echo "[Error] dart build_runner build falló."; echo "Presiona Enter para cerrar."; read)\'',

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
	dbb_term:toggle()
end

return M
