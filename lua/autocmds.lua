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
  callback = function(ev)
    vim.wo.winfixwidth = true
    -- Native `:vertical resize` changes the window but not nvim-tree's stored
    -- width, so the next tree op (opening a file) snaps back to the configured
    -- width. Route resize through nvim-tree's api, which persists the new size.
    local api = require "nvim-tree.api"
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "<C-Left>", function() api.tree.resize { relative = -2 } end, opts)
    vim.keymap.set("n", "<C-Right>", function() api.tree.resize { relative = 2 } end, opts)
  end,
})
