-- LSP completion menu (blink.cmp) and Copilot ghost text, as Zed's completions
-- and edit predictions. Enter accepts a menu item; Tab accepts the menu item
-- or, with the menu closed, the Copilot suggestion.

-- Zed's default edit_predictions.disabled_globs: never send secrets to Copilot.
local secret_files = { "^%.env", "%.pem$", "%.key$", "%.cert$", "%.crt$", "^%.dev%.vars$", "^secrets%.yml$" }

local function accept_copilot()
  local suggestion = require("copilot.suggestion")
  if suggestion.is_visible() then
    suggestion.accept()
    return true
  end
end

return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship a prebuilt fuzzy matcher
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "accept", accept_copilot, "snippet_forward", "fallback" },
      },
      completion = {
        documentation = { auto_show = true },
        list = { selection = { preselect = true } },
      },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Zed: edit_predictions.mode = eager
        keymap = {
          accept = false, -- Tab, through blink.cmp above
          accept_word = "<M-Right>",
          accept_line = "<M-Down>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        yaml = true,
        gitcommit = true,
      },
      -- copilot.lua's default checks, plus the secret files above.
      should_attach = function(buf)
        if not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then
          return false
        end
        local name = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
        for _, pattern in ipairs(secret_files) do
          if name:match(pattern) then
            return false
          end
        end
        return true
      end,
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      -- Hide the ghost text while the completion menu is open.
      local group = vim.api.nvim_create_augroup("user_copilot", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
}
