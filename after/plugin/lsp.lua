-- eslint disable
pcall(function()
  if vim.lsp and vim.lsp._set_config then
    vim.lsp._set_config("eslint", {})
  end
end)

local lsp = require("lsp-zero")
lsp.preset("recommended")

-- Format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function lsp_format_on_save(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({
        async = false,
        filter = function(client)
          -- Only eslint should format JS/TS
          if vim.bo.filetype == "javascript"
              or vim.bo.filetype == "javascriptreact"
              or vim.bo.filetype == "typescript"
              or vim.bo.filetype == "typescriptreact"
          then
            return client.name == "eslint"
          end

          -- Everything else formats normally
          return true
        end
      })
    end
  })
end

lsp.on_attach(function(client, bufnr)
  lsp_format_on_save(bufnr)

  local opts = { buffer = bufnr }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>va", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vr", vim.lsp.buf.references, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "eslint" },

  handlers = {
    function(server)
      require("lspconfig")[server].setup({})
    end,

    -- disable ts formatting
    ts_ls = function()
      require("lspconfig").ts_ls.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          lsp.on_attach(client, bufnr)
        end
      })
    end,

    -- enable eslint formatting
    eslint = function()
      require("lspconfig").eslint.setup({
        settings = {
          format = true,
          codeActionOnSave = { enable = true, mode = "all" },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = true
          lsp.on_attach(client, bufnr)
        end
      })
    end,
  }
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
