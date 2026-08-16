local api = require("libre-view.api")

local M = {}

function M.get_status()
	if api.cache.glucose == "--" then
		return " 🩸 -- mg/dL "
	end
	return string.format(" 🩸 %s mg/dL %s ", api.cache.glucose, api.cache.trend_symbol)
end

return M
