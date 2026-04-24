return {
  -- 1. Optimize nvim-ts-autotag (suspect for '<' lag)
  {
    "windwp/nvim-ts-autotag",
    opts = {
      -- If '<' is still lagging, uncomment the line below to disable it entirely
      -- enabled = false, 
    },
  },

  -- 2. Optimize blink.cmp (Completion Engine)
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        -- Disable ghost text as it can be laggy on Windows
        ghost_text = { enabled = false },
        list = { selection = { preselect = false, auto_insert = true } },
        -- Reduce documentation update frequency
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
      -- Optimization: Don't prefetch completions on insert
      -- This reduces the load on the LSP server significantly
      -- trigger = { prefetch_on_insert = false },
    },
  },

  -- 3. Optimize LSP & Typescript (vtsls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable inlay hints if you don't need them; they are expensive to calculate
      inlay_hints = { enabled = false },
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                -- Increase memory limit for large projects
                maxTsServerMemory = 8192,
              },
            },
            vtsls = {
              experimental = {
                -- Enable server-side fuzzy matching for faster results
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
          },
        },
      },
    },
  },

  -- 4. Disable heavy features in large files
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = function(bufnr)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
  },

  -- 5. Fix DAP for Windows (js-debug-adapter)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function(_, opts)
      local dap = require("dap")
      local adapter = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter.cmd",
          args = { "${port}" },
        },
      }
      dap.adapters["pwa-node"] = adapter
      dap.adapters["node"] = adapter
    end,
  },
}
