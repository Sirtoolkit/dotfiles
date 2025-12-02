vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.diagnostic.config({

	-- Mostrar el mensaje de error al final de la línea
	virtual_text = true,

	-- Mostrar líneas virtuales (solo funciona en versiones muy recientes/nightly de Neovim)
	virtual_lines = false,

	-- No actualizar diagnósticos mientras estás en modo insertar (escribiendo)
	-- Esto reduce el "ruido" visual hasta que terminas de escribir.
	update_in_insert = false,

	-- Subrayar el código con error
	underline = true,

	-- Ordenar por severidad (Errores antes que Advertencias)
	severity_sort = true,

	-- Opcional: Configuración para la ventana flotante (cuando pasas el mouse o usas <leader>d)
	float = {
		border = "rounded",
		source = "always",
	},
})

vim.wo.number = true

vim.opt.swapfile = false
-- Configuración de opciones generales (vim.opt)

vim.opt.backspace:append("nostop") -- Don't stop backspace at insert
vim.opt.breakindent = true -- Wrap indent to match line start
vim.opt.clipboard = "unnamedplus" -- Connection to the system clipboard
vim.opt.cmdheight = 0 -- Hide command line unless needed
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Options for insert mode completion
vim.opt.confirm = true -- Raise a dialog asking if you wish to save the current file(s)
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor

-- Diff options: usamos append para agregar algoritmos sin borrar los defaults
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("linematch:60")

vim.opt.expandtab = true -- Enable the use of space in tab
vim.opt.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.infercase = true -- Infer cases in keyword completion
vim.opt.jumpoptions = {} -- Apply no jumpoptions on startup (Empty list clears it)
vim.opt.laststatus = 3 -- Global statusline (una sola barra para todos los splits)
vim.opt.linebreak = true -- Wrap lines at 'breakat'
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.number = true -- Show numberline
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.shiftround = true -- Round indentation with `>`/`<` to shiftwidth
vim.opt.shiftwidth = 0 -- Number of space inserted for indentation (0 = same as tabstop)

-- Shortmess: usamos append para agregar las flags (s, I, c, C)
vim.opt.shortmess:append("sIcC") -- Disable search count wrap, startup messages, etc.

vim.opt.showmode = false -- Disable showing modes in command line (útil si usas lualine)
vim.opt.showtabline = 2 -- Always display tabline
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.smartcase = true -- Case sensitive searching (if mixed case)
vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.timeoutlen = 1000 -- Tiempo de espera para atajos (1000ms = 1s)
vim.opt.title = true -- Set terminal title to the filename and path
vim.opt.undofile = true -- Enable persistent undo (guarda historial al cerrar)
vim.opt.updatetime = 300 -- Length of time to wait before triggering plugins (git signs, etc)
vim.opt.virtualedit = "block" -- Allow going past end of line in visual block mode
vim.opt.wrap = false -- Disable wrapping of lines longer than the width of window
vim.opt.writebackup = false -- Disable making a backup before overwriting a file

-- Suprimir notificaciones repetidas de Copilot
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg and (msg:match("Copilot") and (msg:match("not signed") or msg:match("not configured"))) and vim.g.copilot_notified then
    return
  end
  original_notify(msg, level, opts)
end
