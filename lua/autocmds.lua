require "nvchad.autocmds"

-- terminal buffers out of bufferline + <Tab> cycle (visible only in their own window)
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.bo.buflisted = false
  end,
})

-- show file path (cwd-relative) at top of each editor window, below bufferline
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
      vim.wo.winbar = " %f"
    end
  end,
})

-- keep nvim-tree width fixed when other windows resize
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.wo.winfixwidth = true
  end,
})
