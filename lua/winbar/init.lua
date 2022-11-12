local M = {}

local function table_contains(tbl, x)
	local found = false
	for _, v in pairs(tbl) do
		if v == x then
			found = true
		end
	end
	return found
end

local function buf_is_attached(buffer)
	local current_buf = vim.api.nvim_get_current_buf()
	if current_buf == buffer then
		return true
	end
	return false
end

local function construct_winbar(buffers)
	local results = ""
	for _, buffer in ipairs(buffers) do
		if vim.fn.buflisted(buffer) == 1 then
			local fn = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":~:.")
            local ext = vim.fn.fnamemodify(fn, ":e")
            local icon, color
            if fn == "Makefile" then
                icon, color = require("nvim-web-devicons").get_icon("makefile", "", {})
            else
                icon, color = require("nvim-web-devicons").get_icon(fn, ext, {})
            end

			local bufinfo = vim.fn.getbufinfo(buffer)[1]
			local winbar_object
			if icon and color then
				winbar_object = " %#" .. color .. "#" .. icon .. " "
			else
				winbar_object = ""
			end
			if buf_is_attached(buffer) then
				winbar_object = winbar_object .. "%*" .. fn .. "%m "
			else
				if bufinfo.changed == 1 then
					winbar_object = winbar_object .. "%#LineNr#" .. fn .. "[+]" .. "%* "
				else
					winbar_object = winbar_object .. "%#LineNr#" .. fn .. "%* "
				end
			end
			results = results .. winbar_object
		end
	end
	return results
end

local blacklist = {
	"help",
	"NvimTree",
	"fugitive",
	"gitcommit",
	"",
}

local function find_buffers()
	local buffers = vim.api.nvim_list_bufs()
	local ft = vim.bo.filetype

	if table_contains(blacklist, ft) then
		return nil
	end
	-- Ignore floating windows
	if vim.api.nvim_win_get_config(0).relative ~= "" then
		return nil
	end

	return construct_winbar(buffers)
end

function M.setup()
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = vim.api.nvim_create_augroup("WinBarGroup", {}),
		callback = function()
			vim.opt_local.winbar = find_buffers()
		end,
	})
end

return M
