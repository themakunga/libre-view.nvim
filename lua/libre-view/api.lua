local M = {}

M.cache = {
	token = nil,
	account_hash = nil,
	patient_id = nil,
	glucose = "--",
	trend_symbol = "→",
	last_updated = "",
}

local function get_base_url(region)
	local urls = {
		cl = "https://api-la.libreview.io",
		latam = "https://api-la.libreview.io",
		eu = "https://api-eu.libreview.io",
		us = "https://api-us.libreview.io",
		ae = "https://api-ae.libreview.io",
	}
	return urls[region:lower()] or "https://api.libreview.io"
end

local function get_trend_symbol(arrow)
	local arrows = {
		[1] = "↓↓",
		[2] = "↓",
		[3] = "→",
		[4] = "↗",
		[5] = "↑↑",
	}
	return arrows[arrow] or "→"
end

function M.fetch(opts)
	local base_url = get_base_url(opts.region or "cl")

	-- PASO 1: LOGIN
	local login_body = vim.json.encode({
		email = opts.email,
		password = opts.password,
	})

	local login_cmd = {
		"curl",
		"-s",
		"-X",
		"POST",
		base_url .. "/llu/auth/login",
		"-H",
		"Content-Type: application/json",
		"-H",
		"version: 4.16.0",
		"-H",
		"product: llu.ios",
		"-d",
		login_body,
	}

	vim.system(login_cmd, { text = true }, function(obj)
		if obj.code ~= 0 or not obj.stdout or obj.stdout == "" then
			return
		end

		local ok, resp = pcall(vim.json.decode, obj.stdout)
		if not ok or not resp.data or not resp.data.authTicket then
			return
		end

		M.cache.token = resp.data.authTicket.Token or resp.data.authTicket.token
		local user_id = resp.data.user.id
		M.cache.account_hash = vim.fn.sha256(user_id)

		-- PASO 2: CONEXIONES
		local conn_cmd = {
			"curl",
			"-s",
			"-X",
			"GET",
			base_url .. "/llu/connections",
			"-H",
			"Content-Type: application/json",
			"-H",
			"Authorization: Bearer " .. M.cache.token,
			"-H",
			"account-id: " .. M.cache.account_hash,
			"-H",
			"version: 4.16.0",
			"-H",
			"product: llu.ios",
		}

		vim.system(conn_cmd, { text = true }, function(conn_obj)
			if conn_obj.code ~= 0 or not conn_obj.stdout then
				return
			end

			local ok_c, c_resp = pcall(vim.json.decode, conn_obj.stdout)
			if not ok_c or not c_resp.data or #c_resp.data == 0 then
				return
			end

			M.cache.patient_id = c_resp.data[1].patientId

			-- PASO 3: OBTENER GLUCOSA Y TENDENCIA
			local graph_cmd = {
				"curl",
				"-s",
				"-X",
				"GET",
				base_url .. "/llu/connections/" .. M.cache.patient_id .. "/graph",
				"-H",
				"Content-Type: application/json",
				"-H",
				"Authorization: Bearer " .. M.cache.token,
				"-H",
				"account-id: " .. M.cache.account_hash,
				"-H",
				"version: 4.16.0",
				"-H",
				"product: llu.ios",
			}

			vim.system(graph_cmd, { text = true }, function(graph_obj)
				if graph_obj.code ~= 0 or not graph_obj.stdout then
					return
				end

				local ok_g, g_resp = pcall(vim.json.decode, graph_obj.stdout)
				if not ok_g or not g_resp.data then
					return
				end

				local item = g_resp.data.connection.glucoseItem
				if item then
					M.cache.glucose = item.ValueInMgPerDl or item.Value or "--"
					M.cache.trend_symbol = get_trend_symbol(item.TrendArrow)
					M.cache.last_updated = os.date("%H:%M")

					-- Redibujar la barra superior en el hilo principal de Neovim
					vim.schedule(function()
						vim.cmd("redrawtabline")
					end)
				end
			end)
		end)
	end)
end

return M
