local M = {}

local gws_term

function M.run()
  local Terminal = require("toggleterm.terminal").Terminal

  if not gws_term or not gws_term:is_open() then
    gws_term = Terminal:new({
      cmd = 'bash -c \'wt switch || (echo; echo "[Error] No se pudo cambiar de worktree. Asegúrate de tener archivos en staging (git add .)"; echo "Presiona Enter para cerrar..."; read)\'',
      dir = "git_dir",
      direction = "float",

      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
      },

      close_on_exit = true,
      auto_start = true,
    })
  end

  gws_term:toggle()
end

return M
