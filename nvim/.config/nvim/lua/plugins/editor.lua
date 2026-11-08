return {
  -- Zed: which_key. Shows pending keys, such as everything under space.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 1000, -- Zed: which_key.delay_ms
      spec = {
        { "<leader>s", group = "search" },
        { "<leader>h", group = "git hunk" },
        { "<leader>c", group = "code" },
        { "<leader>u", group = "toggle" },
        { "<leader>d", group = "debug" },
        -- which-key lists gn / gN only in Normal mode; show them after an
        -- operator too (cgn, dgn) and in Visual mode.
        { "gn", desc = "Next search match", mode = { "o", "x" } },
        { "gN", desc = "Previous search match", mode = { "o", "x" } },
      },
    },
  },

  -- Zed text objects: af/if function, ac/ic class, aa/ia argument.
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      })
    end,
  },

  -- Search and replace across the project, like Zed's project search with replace.
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { transient = true },
    keys = {
      {
        "<leader>sr",
        function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
        desc = "Search and replace in project",
      },
      {
        "<leader>sr",
        function() require("grug-far").with_visual_selection() end,
        mode = "x",
        desc = "Search and replace selection",
      },
    },
  },

  -- Jump anywhere on screen: s + 1-2 letters + the shown label. Replaces s
  -- (substitute character; cl does the same). S in Visual mode stays with
  -- nvim-surround.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "o" }, desc = "Flash select syntax node" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Flash syntax search" },
      { "<C-s>", function() require("flash").toggle() end, mode = "c", desc = "Toggle flash in / search" },
    },
  },

  -- Highlight TODO, FIXME, HACK, NOTE, … in comments; jump and search them.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "TODO comments" },
    },
  },

  -- Zed: always_treat_brackets_as_autoclosed.
  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },

  -- Zed vim mode: ys / cs / ds surround.
  { "kylechui/nvim-surround", version = "^4.0.0", event = "VeryLazy", opts = {} },

  -- Zed vim mode multi-cursor keys. Edit with normal commands (ciw, A, …)
  -- and they apply at every cursor; Esc clears the extra cursors.
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      { "gl", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor at next match" },
      { "gL", function() require("multicursor-nvim").matchAddCursor(-1) end, mode = { "n", "x" }, desc = "Add cursor at previous match" },
      { "g>", function() require("multicursor-nvim").matchSkipCursor(1) end, mode = { "n", "x" }, desc = "Skip match, add next" },
      { "g<", function() require("multicursor-nvim").matchSkipCursor(-1) end, mode = { "n", "x" }, desc = "Skip match, add previous" },
      { "ga", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "x" }, desc = "Add cursors at all matches" },
      { "gA", function() require("multicursor-nvim").appendVisual() end, mode = "x", desc = "Cursor at end of each selected line" },
      { "gI", function() require("multicursor-nvim").insertVisual() end, mode = "x", desc = "Cursor at start of each selected line" },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      -- These keys apply only while there are several cursors.
      mc.addKeymapLayer(function(layer_set)
        layer_set({ "n", "x" }, "[[", mc.prevCursor)
        layer_set({ "n", "x" }, "]]", mc.nextCursor)
        layer_set({ "n", "x" }, "<leader>x", mc.deleteCursor)
        layer_set("n", "<Esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
      vim.api.nvim_set_hl(0, "MultiCursorCursor", { reverse = true })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
    end,
  },

  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { globalstatus = true, section_separators = "", component_separators = "" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
