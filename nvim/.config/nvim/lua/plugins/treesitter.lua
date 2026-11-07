-- nvim-treesitter's main branch: installs parsers with tree-sitter-cli
-- (Homebrew) and leaves highlighting to Neovim's built-in Tree-sitter.
local parsers = {
  "bash", "diff", "go", "gomod", "gosum", "gowork", "json", "lua", "luadoc",
  "markdown", "markdown_inline", "python", "query", "regex", "sql", "toml",
  "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Asynchronous; already installed parsers are skipped.
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  -- Queries for mini.ai's function/class text objects, and Zed's ]m [m
  -- (method start) and ]M [M (method end) motions.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
    opts = { move = { set_jumps = true } },
    keys = {
      { "]m", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next function" },
      { "[m", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous function" },
      { "]M", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next function end" },
      { "[M", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous function end" },
      -- Zed: ]/ [/ next / previous comment.
      { "]/", function() require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next comment" },
      { "[/", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous comment" },
    },
  },
}
