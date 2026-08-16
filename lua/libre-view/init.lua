local api = require("libre-view.api")
local widget = require("libre-view.widget")

local M = {}

M.config = {
	email = "",
	password = "",
	region = "cl",
	update_interval = 300, -- en segundos (5 min)
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	if M.config.email == "" or M.config.password == "" then
		vim.notify("[libre-view.nvim] Falta email o password en setup()", vim.log.levels.WARN)
		return
	end

	-- Primera ejecución de consulta
	api.fetch(M.config)

	-- Neovim 0.12 API NATIVA: vim.uv.new_timer()
	local timer = vim.uv.new_timer()
	timer:start(
		M.config.update_interval * 1000,
		M.config.update_interval * 1000,
		vim.schedule_wrap(function()
			api.fetch(M.config)
		end)
	)
end

-- Exportar el widget para bufferline
M.widget = widget.get_status

return M
