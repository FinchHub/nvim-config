return {

  --Mason is the plugin that downloads and manages LSP servers, formatters, linters, and debuggers.
  --Allows you to search and download whichever one you want.
  {
    "mason-org/mason.nvim",
    name = "mason",
    opts = {}
  },

  --Acts as a bridge between Mason and Neovim's built-in LSP client. Auto-installs LSP servers, matches Mason's
  --server names to config names expected by Neovim, and just makes the setup that much easier.
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "clangd",
          "cssls",
          "html",
          "ts_ls",
          "emmet_language_server",
          "eslint",
        },
        automatic_installation = true,
      })
    end,
  },

  --Plugin maintained by Neovim that provides easy configs for connecting to LSP servers. Just handles the boilerplate
  --So Neovim can actually connect to the LSP servers.
  {
    "neovim/nvim-lspconfig",
    config = function()
      local servers = {
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "cssls",
        "html",
        "ts_ls",
        "emmet_language_server",
        "eslint",
      }

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover" })
      vim.lsp.config('*', {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      })

      vim.o.winborder = 'rounded'
    end,
  },

  --Complements LSP by providing better syntax highlighting and language parsing.
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
      lazy = false,
      config = function()
        require("nvim-treesitter").install({
          "c", "cpp", "lua", "rust", "vim", "vimdoc",
          "html", "css", "javascript", "typescript", "tsx",
        })

        vim.api.nvim_create_autocmd("FileType", {
          callback = function(args)
            local ft = vim.bo[args.buf].filetype
            local lang = vim.treesitter.language.get_lang(ft)
            if lang and pcall(vim.treesitter.start, args.buf, lang) then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })
      end,
    },

  -- For automatically closing tags.
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre" },
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = { "html", "javascript", "javascriptreact", "typescriptreact", "tsx", "jsx" },
      })
    end,
  },

  --Handles code-completion.
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = { nerd_font_variant = 'mono' },
    },
  },

  -- For managing terminal windows. ctrl+\ to open.
  {
    "akinsho/toggleterm.nvim",
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
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    keys = {
      { "<leader>tf", "<cmd>Telescope find_files<CR>",   desc = "Telescope Find Files" },
      { "<leader>tb", "<cmd>Telescope file_browser<CR>", desc = "Telescope File Browser" },
    },
    config = function()
      require('telescope').setup({
        extensions = {
          file_browser = {
            hijack_netrw = true,
          },
        },
      })
      require('telescope').load_extension('file_browser')
    end,
  },

  -- For starting a live server when working with webpages.
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    keys = {
      { "<leader>ls", "<cmd>LiveServerStart<CR>", desc = "Live Server: Start" },
      { "<leader>lS", "<cmd>LiveServerStop<CR>",  desc = "Live Server: Stop" },
    },
    init = function()
      vim.g.live_server = {}
    end,
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
  },

  -- Code formatting
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          html = { "prettier" },
          css = { "prettier" },
          javascript = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format buffer" })
    end
  },

  -- Color picker utility for working with RGB/Hex/HSL
  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    keys = {
      { "<leader>cp", "<cmd>Colortils picker<CR>",   desc = "colortils picker" },
      { "<leader>cg", "<cmd>Colortils gradient<CR>", desc = "colortils gradient" },
      { "<leader>cl", "<cmd>Colortils lighten<CR>",  desc = "colortils lighten" },
      { "<leader>cd", "<cmd>Colortils darken<CR>",   desc = "colortils darken" },
    },
    config = function()
      require("colortils").setup({
        register = "+",
        color_preview = "█ %s",
        default_format = "hex",
        default_color = "#000000",
        border = "rounded",
        mappings = {
          increment = "l",
          decrement = "h",
          increment_big = "L",
          decrement_big = "H",
          min_value = "0",
          max_value = "$",
          set_register_default_format = "<cr>",
          set_register_choose_format = "g<cr>",
          replace_default_format = "<m-cr>",
          replace_choose_format = "g<m-cr>",
          export = "E",
          set_value = "c",
          transparency = "T",
          choose_background = "B",
          quit_window = { "q", "<esc>" }
        }
      })
    end,
  },

  -- Provides visual colors for color codes.
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual", -- or "foreground" or "virtual"
        virtual_symbol = '■',
        virtual_symbol_position = 'inline',
      })
    end,
  },

  -- Provides code folding. Keymapped for simple folding/unfolding with 'z'.
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost" },
    config = function()
      -- ufo setup
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })

      --
      -- ensure all folds are open by default
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- optional: map 'z' to toggle the fold under cursor
      vim.keymap.set('n', '<CR>', 'za', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>zO', 'zR', { desc = "Open all folds" })
      vim.keymap.set('n', '<leader>zC', 'zM', { desc = "Close all folds" })
    end,
  },

  -- For nvim tabs
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.showtabline = 2

      require('tabby').setup({
        preset = 'active_wins_at_tail',
        option = {
          theme = {
            fill = 'TabLineFill',
            head = 'TabLine',
            current_tab = 'TabLineSel',
            tab = 'TabLine',
            win = 'TabLine',
            tail = 'TabLine',
          },
          nerdfont = true,
          lualine_theme = nil,
          tab_name = {
            name_fallback = function(tabid)
              local default_names = {
                "Editor", "Editor", "Terminal", "Logs", "Other"
              }
              return default_names[tabid] or ("Tab " .. tabid)
            end,
          },
          buf_name = { mode = 'unique' },
        },
      })

      -- Create a new tab
      vim.keymap.set('n', '<leader>Tn', ':tabnew<CR>', { noremap = true, silent = true, desc = "New Tab" })

      -- Jump to specific tab using numbers 1-9
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, i .. 'gt', { noremap = true, silent = true, desc = "Go to Tab " .. i })
      end

      -- Close current tab
      vim.keymap.set('n', '<leader>Tc', ':tabclose<CR>', { noremap = true, silent = true, desc = "Close Tab" })

      -- Rename current tab (Tabby function)
      vim.keymap.set('n', '<leader>tr', function()
        require('tabby.tabline').rename_tab()
      end, { noremap = true, silent = true, desc = "Rename Tab" })
    end
  },

  -- nerd web devicons
  { "nvim-tree/nvim-web-devicons", opts = {} },



}
