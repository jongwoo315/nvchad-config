require "nvchad.autocmds"

-- keep nvim-tree width fixed when other windows resize
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.wo.winfixwidth = true
  end,
})
