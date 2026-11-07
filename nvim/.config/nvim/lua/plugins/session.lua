-- Sessions, like Zed reopening a project's files: opening Neovim on a
-- directory (`v`, `nvim`, `nvim .`) restores that directory's session for the
-- current git branch. Opening specific files doesn't save a session, so it
-- can't overwrite the project's one. Space p (lua/plugins/snacks.lua) lists
-- recent projects and restores their sessions too.
local function opened_on_directory()
  local argv = vim.fn.argv()
  return #argv == 0 or (#argv == 1 and vim.fn.isdirectory(argv[1]) == 1)
end

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    init = function()
      -- Save files and layout, not empty or terminal windows.
      vim.opt.sessionoptions = { "buffers", "curdir", "folds", "globals", "help", "skiprtp", "tabpages", "winsize" }

      local group = vim.api.nvim_create_augroup("user_session", { clear = true })
      -- Remember whether the file tree was open (an uppercase global is saved
      -- with the session), then close snacks windows so they aren't saved.
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "PersistenceSavePre",
        callback = function()
          vim.g.SessionExplorer = #Snacks.picker.get({ source = "explorer", tab = false }) > 0 and 1 or 0
          for _, picker in ipairs(Snacks.picker.get({ tab = false })) do
            picker:close()
          end
        end,
      })
      -- After restoring, drop the directory buffer and file tree that `nvim .`
      -- opened, then reopen the tree if it was open when the session was saved,
      -- keeping focus on the restored file.
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "PersistenceLoadPost",
        callback = function()
          for _, picker in ipairs(Snacks.picker.get({ tab = false })) do
            picker:close()
          end
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            local is_dir = name ~= "" and vim.fn.isdirectory(name) == 1
            local is_empty = name == "" and vim.bo[buf].buftype == "" and not vim.bo[buf].modified
              and vim.api.nvim_buf_line_count(buf) <= 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
            if vim.bo[buf].buflisted and (is_dir or is_empty) then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end
          if vim.g.SessionExplorer ~= 0 then
            Snacks.explorer({ enter = false }) -- show it without taking focus
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        nested = true, -- let restored buffers trigger their FileType, LSP, …
        callback = function()
          local persistence = require("persistence")
          if opened_on_directory() then
            persistence.load()
          else
            persistence.stop()
          end
        end,
      })
    end,
    keys = {
      { "<leader>sS", function() require("persistence").select() end, desc = "Sessions" },
    },
  },
}
