-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }

M.ui = {
	tabufline = {
		enabled = false,
	},

	statusline = {
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "venv", "cwd", "cursor" },
		modules = {
			venv = function()
				local ok, vs = pcall(require, "venv-selector")
				if not ok then
					return ""
				end
				local venv = vs.venv()
				if not venv or venv == "" then
					return ""
				end
				local name = vim.fn.fnamemodify(venv, ":t")
				-- ".venv"/"venv" says nothing — show project dir instead
				if name == ".venv" or name == "venv" then
					name = vim.fn.fnamemodify(venv, ":h:t")
				end
				return "%#St_gitIcons#(" .. name .. ") "
			end,
		},
	},
}

return M
