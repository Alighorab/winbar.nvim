local M = {}

local blacklist = {
	"help",
	"NvimTree",
	"fugitive",
	"gitcommit",
    "Trouble",
    "dashboard",
    "toggleterm",
    "git",
	"",
}

local opts = {
    filename = "relative"
}

local bufopts = {
    name = {
        full = function(bufnr) return vim.api.nvim_buf_get_name(bufnr) end,
        path = function(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:.:h") .. "/" end,
        abs_path = function(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h") .. "/" end,
        tail = function(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t") end,
        ext = function(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e") end,
    }
}

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

local function parse_buf_name(abs, path, name)
    local filename = {
        ["abs"] = function() return abs .. name end,
        ["relative"] = function() return path .. name end,
        ["short"] = function()
            local result = {}
            for w in string.gmatch(path, "%a+/") do
                table.insert(result, string.sub(w, 1, 1) .. "/")
            end
            table.insert(result, name)
            return table.concat(result)
        end
    }
    return filename[opts.filename]()
end

local function get_icon(name, extension)
    local icon, color
    if name == "Makefile" then
        icon, color = require("nvim-web-devicons").get_icon("makefile", "", {})
    else
        icon, color = require("nvim-web-devicons").get_icon(name, extension, {})
    end
    return icon, color
end

local function construct_winbar(buffers)
    local winbar = {}
	for _, bufnr in ipairs(buffers) do
		if vim.fn.buflisted(bufnr) == 1 then
			local path = bufopts.name.path(bufnr)
            local basename = bufopts.name.tail(bufnr)
            local ext = bufopts.name.ext(bufnr)
            local abs_path = bufopts.name.abs_path(bufnr)

            local fn = parse_buf_name(abs_path, path, basename)
            local icon, color = get_icon(basename, ext)
			local bufinfo = vim.fn.getbufinfo(bufnr)[1]

			local winbar_object = ""
			if icon and color then
				winbar_object = " %#" .. color .. "#" .. icon .. " "
			end
            table.insert(winbar, winbar_object)
			if buf_is_attached(bufnr) then
				winbar_object = "%*" .. fn .. "%m "
			else
				if bufinfo.changed == 1 then
					winbar_object = "%#LineNr#" .. fn .. "[+]" .. "%* "
				else
					winbar_object = "%#LineNr#" .. fn .. "%* "
				end
			end
            table.insert(winbar, winbar_object)
		end
	end
	return table.concat(winbar)
end

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

function M.setup(options)
    for k, v in pairs(options) do
        if k then
            opts[k] = v
        end
    end
	vim.api.nvim_create_autocmd({"BufWinEnter", "BufLeave"}, {
		group = vim.api.nvim_create_augroup("WinBarGroup", {}),
		callback = function()
			vim.opt_local.winbar = find_buffers()
		end,
	})
end

return M
