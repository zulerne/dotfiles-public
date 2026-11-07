-- Pickers, file tree, terminal and lazygit, with Zed's space-leader keys.

-- Zed: space e toggles focus on the project panel, and closes it from there.
local function toggle_explorer()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if not explorer then
    Snacks.explorer()
  elseif explorer:is_focused() then
    explorer:close()
  else
    explorer:focus()
  end
end

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true, replace_netrw = true },
      indent = { enabled = true }, -- Zed: indent guides
      input = { enabled = true },
      lazygit = {
        -- `e` in lazygit: quit lazygit and open the file as a buffer in this
        -- Neovim. The nvim-remote preset would open a new tab page instead.
        config = {
          os = {
            edit = 'nvim --server "$NVIM" --remote-send q && nvim --server "$NVIM" --remote {{filename}}',
            editAtLine = 'nvim --server "$NVIM" --remote-send q && nvim --server "$NVIM" --remote {{filename}}'
              .. ' && nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
          },
        },
      },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          -- Open in the list (normal mode): j/k to move, Enter to open,
          -- dd to close a buffer, / or i to type a filter.
          buffers = { focus = "list" },
          -- vim.ui.select: delete confirmation in the tree, code actions (g.).
          select = { focus = "list" },
          diagnostics = { focus = "list" },
          diagnostics_buffer = { focus = "list" },
          explorer = {
            hidden = true,
            actions = {
              focus_editor = function()
                vim.cmd.wincmd("p")
              end,
              -- Zed: move to the parent folder without collapsing it.
              select_parent = function(picker, item)
                if not item then
                  return
                end
                local parent = vim.fs.dirname(item.file)
                if parent ~= picker:cwd() and #parent > #picker:cwd() then
                  require("snacks.explorer.actions").update(picker, { target = parent })
                end
              end,
            },
            win = {
              list = {
                keys = {
                  ["<Esc>"] = "focus_editor", -- Zed: escape returns to the editor
                  ["-"] = "select_parent", -- Zed: project_panel::SelectParent
                },
              },
            },
          },
        },
      },
      quickfile = { enabled = true },
      words = { enabled = true }, -- highlight references of the word under the cursor
    },
    keys = {
      -- Zed keymap.json
      { "<leader>e", toggle_explorer, desc = "File tree" },
      { "<leader>f", function() Snacks.picker.smart() end, desc = "Find file" },
      { "<leader>b", function() Snacks.picker.buffers() end, desc = "Open buffers" },
      { "<leader>q", function() Snacks.bufdelete() end, desc = "Close buffer" },
      { "<leader>g", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>t", function() Snacks.terminal() end, desc = "Terminal" },
      { "<M-Space>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Terminal" },

      -- Search
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Search in project" },
      { "g/", function() Snacks.picker.grep() end, desc = "Search in project" }, -- Zed: g /
      { "<leader>sw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Search word" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last search" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (project)" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (file)" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
      { "<leader>sn", function() Snacks.notifier.show_history() end, desc = "Notifications" },

      -- Jump between highlighted references
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference" },
    },
  },
}
