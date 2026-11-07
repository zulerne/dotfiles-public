-- Language servers: nvim-lspconfig supplies server configs, Mason installs the
-- servers and formatters that are not installed by the Brewfile.

-- Servers enabled with vim.lsp.enable. gopls comes from the Brewfile's go list.
local servers = { "gopls", "basedpyright", "ruff", "lua_ls", "jsonls", "yamlls", "bashls", "taplo" }

-- Mason package names.
local tools = {
  "basedpyright",
  "ruff",
  "lua-language-server",
  "json-lsp",
  "yaml-language-server",
  "bash-language-server",
  "taplo",
  "stylua",
  "shfmt",
}

-- Zed's default vim-mode LSP keys, plus Neovim's own defaults (K, grn, gra,
-- grr, gri, grt, ]d, [d), which still work.
local function on_attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
  end

  map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
  map("gD", function() Snacks.picker.lsp_declarations() end, "Go to declaration")
  map("gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
  map("gI", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
  map("gA", function() Snacks.picker.lsp_references() end, "All references")
  map("gs", function() Snacks.picker.lsp_symbols() end, "Symbols in file")
  map("gS", function() Snacks.picker.lsp_workspace_symbols() end, "Symbols in project")
  map("cd", vim.lsp.buf.rename, "Rename symbol")
  -- Zed: <C-w> g d / <C-w> g D open the definition / type definition in a split.
  map("<C-w>gd", function() vim.cmd.vsplit(); vim.lsp.buf.definition() end, "Definition in split")
  map("<C-w>gD", function() vim.cmd.vsplit(); vim.lsp.buf.type_definition() end, "Type definition in split")
  map("g.", vim.lsp.buf.code_action, "Code actions", { "n", "x" })
  -- Zed: g h opens the hover (signature and docs). Errors on the current line
  -- show inline; <C-w>d opens them in a float.
  map("gh", vim.lsp.buf.hover, "Hover documentation")
  map("g]", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
  map("g[", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")

  -- Zed: inlay_hints.enabled
  if client and client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
  end
  -- Zed: code_lens = on. Run the lens under the cursor with grx (Neovim default).
  if client and client:supports_method("textDocument/codeLens") then
    vim.lsp.codelens.enable(true, { bufnr = args.buf })
  end

  map("<leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
  end, "Toggle inlay hints")
end

return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- puts Mason's bin directory on PATH before servers start
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = { ensure_installed = tools },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
            },
            hint = { enable = true },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = on_attach,
      })
      vim.lsp.enable(servers)
    end,
  },
}
