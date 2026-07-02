require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "LSP rename" })

-- bufferline: cycle buffers (visual order)
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer next" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer prev" })

-- close buffer, keep window layout (tabufline disabled → close_buffer() crashes)
map("n", "<leader>x", function()
  local cur = vim.api.nvim_get_current_buf()
  vim.cmd "bprevious"
  vim.cmd("bdelete " .. cur)
end, { desc = "Close buffer" })

-- gitsigns: inline blame per line (toggle)
map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git blame line (toggle)" })

-- blame popup: full commit message + hunk for current line
map("n", "<leader>gB", function()
  require("gitsigns").blame_line { full = true }
end, { desc = "Git blame popup (full)" })

-- open current line's commit as full diff in diffview
map("n", "<leader>gc", function()
  local file = vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype ~= "" or vim.fn.filereadable(file) == 0 then
    vim.notify("Not a file on disk — blame unavailable here", vim.log.levels.WARN)
    return
  end
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = string.format(
    "git -C %s blame -L %d,%d --porcelain %s",
    vim.fn.shellescape(vim.fn.fnamemodify(file, ":h")),
    line, line,
    vim.fn.shellescape(file)
  )
  local out = vim.fn.systemlist(cmd)
  local sha = out[1] and out[1]:match "^(%x+)"
  if vim.v.shell_error ~= 0 or not sha then
    vim.notify("git blame failed: " .. (out[1] or ""), vim.log.levels.WARN)
    return
  end
  if sha:match "^0+$" then
    vim.notify("Line not committed yet", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewOpen " .. sha .. "^!")
end, { desc = "Open commit of current line" })

-- window resize (macOS: Ctrl+화살표가 Mission Control에 잡히면 시스템 설정 > 키보드 단축키에서 해제)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window height +" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window height -" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window width +" })

-- persistence.nvim: session restore
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Session restore (cwd)" })
map("n", "<leader>ql", function() require("persistence").load { last = true } end, { desc = "Session restore last" })
map("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Session don't save" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
