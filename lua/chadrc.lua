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

-- Alt+v / Alt+h 터미널 크기 (세션엔 터미널 저장 안 하므로 여기가 크기의 단일 기준)
M.term = {
	sizes = { sp = 0.3, vsp = 0.3 },
}

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
