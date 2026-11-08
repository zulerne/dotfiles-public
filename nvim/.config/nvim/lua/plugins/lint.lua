-- golangci-lint diagnostics in the editor, run in the background when a Go file
-- is opened or saved. Uses the project's .golangci.yml when there is one;
-- otherwise golangci-lint's defaults (errcheck, govet, ineffassign,
-- staticcheck, unused). golangci-lint comes from the Brewfile.
return {
  {
    "mfussenegger/nvim-lint",
    ft = "go", -- load once the filetype is known, so the first lint runs
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {}
      if vim.fn.executable("golangci-lint") == 1 then
        lint.linters_by_ft.go = { "golangcilint" }
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
      lint.try_lint() -- the buffer that triggered loading
    end,
  },
}
