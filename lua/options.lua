require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- resize/split 시 다른 창 자동 균등화 금지 (nvim-tree 폭 유지)
vim.o.equalalways = false

-- 세션에 터미널 저장 금지 — 복원된 터미널은 프로세스 없는 빈 껍데기 + Alt+v 토글과 중복됨
vim.opt.sessionoptions:remove "terminal"

-- treesitter folding: za toggle, zM close all, zR open all, zm/zr by level
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99 -- open all folds when opening file
vim.o.foldtext = "" -- keep syntax colors on folded line
