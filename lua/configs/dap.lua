local dap = require "dap"
local dapui = require "dapui"

-- panels on right so nvim-tree keeps left edge
dapui.setup {
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.4 },
        { id = "breakpoints", size = 0.15 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.2 },
      },
      position = "right",
      size = 40,
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size = 10,
    },
  },
}

-- auto open/close dap-ui with debug session
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })

-- python adapter: prefer mason's debugpy, fall back to active venv / system python
local mason_debugpy = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
if vim.fn.executable(mason_debugpy) == 1 then
  require("dap-python").setup(mason_debugpy)
else
  require("dap-python").setup "python3"
end

-- Django/FastAPI launch configs (on top of dap-python defaults)
table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Django runserver",
  program = vim.fn.getcwd() .. "/manage.py",
  args = { "runserver", "--noreload" }, -- reloader forks, debugger loses process
  django = true,
  justMyCode = false,
})
table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "FastAPI (uvicorn)",
  module = "uvicorn",
  args = { "main:app", "--reload=false" },
  justMyCode = false,
})
