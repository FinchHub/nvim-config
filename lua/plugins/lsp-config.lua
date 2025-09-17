return {
  
  --Mason is the plugin that downloads and manages LSP servers, formatters, linters, and debuggers.
  --Allows you to search and download whichever one you want.
  { "mason-org/mason.nvim",
    name = "mason",
    opts = {}
  },

  --Acts as a bridge between Mason and Neovim's built-in LSP client. Auto-installs LSP servers, matches Mason's
  --server names to config names expected by Neovim, and just makes the setup that much easier.
  { "mason-org/mason-lspconfig.nvim",
    name = "mason-lspconfig",
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "cssls",
        "html",
        "ts_ls",
      },
    },
  },

  --Plugin maintained by Neovim that provides easy configs for connecting to LSP servers. Just handles the boilerplate
  --So Neovim can actually connect to the LSP servers.
 { "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.clangd.setup({})
    end
  },
 
  --Complements LSP by providing better syntax highlighting and language parsing.
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "cpp", "lua", "rust", "vim", "html", "css", "javascript" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        })
    end,
  },

  --Handles code-completion. 
  { 'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = { nerd_font_variant = 'mono' },
    },
  },

  -- For managing terminal windows. ctrl+\ to open.
  { "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<leader>\]],
        direction = "horizontal",
      })

    vim.keymap.set("n", "<leader>\\", function()
      require("toggleterm").toggle()
    end, { desc = "Toggle terminal" })

    vim.keymap.set("t", "<leader>\\", function()
      require("toggleterm").toggle()
    end, { desc = "Toggle terminal", noremap = true })
  end
  },

  -- Telescope is a fuzzy finder file browser.
  { 'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    branch = '0.1.x',
    config = function()
        require('telescope').setup({
          mappings = {
        }
      })
    end,
  },

  -- For starting a live server when working with webpages.
{
  "barrett-ruth/live-server.nvim",
  build = "pnpm add -g live-server",
  keys = {
    { "<leader>ls", "<cmd>LiveServerStart<CR>", desc = "Live Server: Start" },
    { "<leader>lS", "<cmd>LiveServerStop<CR>", desc = "Live Server: Stop" },
  },
  config = true,
},


  -- Provides an interface that shows Nvim keybinds.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
}


