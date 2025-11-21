require("conform").setup({
  notify_on_error = false,
  format_on_save = {
    lsp_fallback = true, -- IMPORTANT
    timeout_ms = 1500,
  },

  formatters_by_ft = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    svelte = { "prettier" },
    astro = { "prettier" },
  },

  formatters = {
    prettier = {
      condition = function(ctx)
        return vim.fs.find({
          "node_modules/prettier",
          "node_modules/.bin/prettier",
        }, { upward = true, path = ctx.filename })[1] ~= nil
      end,
    },
  },
})
