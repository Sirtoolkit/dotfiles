return {
  "windwp/nvim-ts-autotag",
  -- Cargamos el plugin al leer un archivo o crear uno nuevo
  event = { "BufReadPre", "BufNewFile" },
  opts = {}, -- Carga la configuración por defecto
}
