require "nvchad.autocmds"

-- terminal buffers out of bufferline + <Tab> cycle (visible only in their own window)
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.bo.buflisted = false
  end,
})

-- keep nvim-tree width fixed when other windows resize
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.wo.winfixwidth = true
  end,
})
