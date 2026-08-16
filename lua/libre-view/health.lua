local M = {}

function M.check()
  vim.health.start("Chequeando dependencias de libre-view.nvim")

  -- 1. Chequear Curl
  if vim.fn.executable("curl") == 1 then
    vim.health.ok("`curl` está instalado.")
  else
    vim.health.error("`curl` no encontrado. Requiere curl para llamadas a la API.")
  end

  -- 2. Chequear Configuración
  local config = require("libre-view").config
  if config.email and config.email ~= "" then
    vim.health.ok("Email configurado: " .. config.email)
  else
    vim.health.error("No se ha configurado un email en setup().")
  end

  if config.password and config.password ~= "" then
    vim.health.ok("Contraseña configurada (oculta).")
  else
    vim.health.error("No se ha configurado una contraseña en setup().")
  end
end

return M
