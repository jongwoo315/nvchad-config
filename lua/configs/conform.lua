local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" }, -- isort 먼저 (import 정렬 후 포맷)
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
