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

-- persist nvim-tree width across persistence.nvim sessions. mksession stores the
-- window width (winsize), but on load nvim-tree re-applies its configured width
-- (30), so the restored tree ignores the session size. Record the width on save
-- and re-apply it via nvim-tree's api after the session loads.
local tree_width_file = vim.fn.stdpath "state" .. "/nvim_tree_width"

local function nvimtree_win()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "NvimTree" then
      return w
    end
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceSavePre",
  callback = function()
    local w = nvimtree_win()
    if w then
      pcall(vim.fn.writefile, { tostring(vim.api.nvim_win_get_width(w)) }, tree_width_file)
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceLoadPost",
  callback = function()
    if vim.fn.filereadable(tree_width_file) == 0 then
      return
    end
    local width = tonumber((vim.fn.readfile(tree_width_file))[1])
    if not width then
      return
    end
    -- defer so it runs after nvim-tree has settled its own width on load
    vim.defer_fn(function()
      if nvimtree_win() then
        require("nvim-tree.api").tree.resize { width = width }
      end
    end, 100)
  end,
})
