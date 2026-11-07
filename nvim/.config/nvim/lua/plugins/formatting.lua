-- Zed: format_on_save = on. Formatters per filetype, falling back to the LSP.
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "x" }, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
        python = { "ruff_organize_imports", "ruff_format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = { timeout_ms = 1000 },
    },
  },
}
