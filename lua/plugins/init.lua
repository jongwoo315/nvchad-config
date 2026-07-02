return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", separator = true },
          { filetype = "dapui_scopes", text = "Debug", separator = true },
          { filetype = "dapui_breakpoints", separator = true },
          { filetype = "dapui_stacks", separator = true },
          { filetype = "dapui_watches", separator = true },
          { filetype = "neotest-summary", text = "Tests", separator = true },
          { filetype = "DiffviewFiles", text = "Diffview", separator = true },
        },
      },
    },
  },

  -- gitsigns (NvChad built-in): blame follows cursor line
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- on by default; <leader>gb toggles
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol",
      },
    },
  },

  -- git: lazygit TUI (big ops) + diffview (diff/merge UI)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit current file" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gd",
        function()
          if require("diffview.lib").get_current_view() then
            vim.cmd "DiffviewClose"
          else
            vim.cmd "DiffviewOpen"
          end
        end,
        desc = "Diffview toggle",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview file history" },
    },
  },

  -- debugging: dap + ui + python adapter (debugpy installed via :MasonInstall debugpy)
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "DAP terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
    },
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      require "configs.dap"
    end,
  },

  -- testing: neotest + python adapter (pytest / pytest-django)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Test nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test file" },
      { "<leader>td", function() require("neotest").run.run { strategy = "dap" } end, desc = "Test nearest (debug)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output.open { enter = true } end, desc = "Test output" },
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
            runner = "pytest",
          },
        },
        status = { virtual_text = true, signs = true },
        output = { open_on_run = true },
      }
    end,
  },

  -- python venv switcher: updates pyright + dap python path on select
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope.nvim",
    },
    ft = "python",
    cmd = "VenvSelect",
    keys = { { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select python venv" } },
    opts = {},
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
