-- ~/.config/nvim/lua/user/pod_install.lua

local M = {}

-- Variable para almacenar nuestra terminal flotante
local pod_term

--- Ejecuta 'pod install' en una terminal flotante
function M.install()
	-- Carga el plugin 'toggleterm'
	local Terminal = require("toggleterm.terminal").Terminal

	-- Si la terminal no existe o ya se cerró, crea una nueva
	if not pod_term or not pod_term:is_open() then
		pod_term = Terminal:new({
			--
			-- Ejecutamos 'pod install' dentro de un shell interactivo de zsh.
			-- Si 'pod install' falla (el '||'), mostramos un mensaje de error y
			-- esperamos a que el usuario presione Enter ('read') antes de cerrar.
			cmd = 'zsh -i -c \'cd ios && pod install || (echo; echo "[Error] pod install falló."; echo "Presiona Enter para cerrar."; read)\'',

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

			-- Cierra la ventana automáticamente CUANDO el proceso 'zsh' termine
			close_on_exit = true,

			-- Abre la terminal en modo inserción, lista para la interacción
			auto_start = true,
		})
	else
		-- Si la terminal ya existe, actualizamos el comando
		pod_term.cmd = 'zsh -i -c \'cd ios && pod install || (echo; echo "[Error] pod install falló."; echo "Presiona Enter para cerrar."; read)\''
	end

	-- Muestra u oculta la terminal
	pod_term:toggle()
end

--- Ejecuta 'pod update' en una terminal flotante
function M.update()
	-- Carga el plugin 'toggleterm'
	local Terminal = require("toggleterm.terminal").Terminal

	-- Si la terminal no existe o ya se cerró, crea una nueva
	if not pod_term or not pod_term:is_open() then
		pod_term = Terminal:new({
			--
			-- Ejecutamos 'pod update' dentro de un shell interactivo de zsh.
			-- Si 'pod update' falla (el '||'), mostramos un mensaje de error y
			-- esperamos a que el usuario presione Enter ('read') antes de cerrar.
			cmd = 'zsh -i -c \'cd ios && pod update || (echo; echo "[Error] pod update falló."; echo "Presiona Enter para cerrar."; read)\'',

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

			-- Cierra la ventana automáticamente CUANDO el proceso 'zsh' termine
			close_on_exit = true,

			-- Abre la terminal en modo inserción, lista para la interacción
			auto_start = true,
		})
	else
		-- Si la terminal ya existe, actualizamos el comando
		pod_term.cmd = 'zsh -i -c \'cd ios && pod update || (echo; echo "[Error] pod update falló."; echo "Presiona Enter para cerrar."; read)\''
	end

	-- Muestra u oculta la terminal
	pod_term:toggle()
end

return M
