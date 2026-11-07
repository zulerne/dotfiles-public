-- Git signs in the gutter with Zed's vim-mode git keys. Space g opens lazygit
-- (lua/plugins/snacks.lua).
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        -- In diff mode keep Vim's own ]c [c do dp.
        local function diff_or(keys, fn)
          return function()
            if vim.wo.diff then
              vim.cmd.normal({ keys, bang = true })
            else
              fn()
            end
          end
        end

        map("n", "]c", diff_or("]c", function() gs.nav_hunk("next") end), "Next git change")
        map("n", "[c", diff_or("[c", function() gs.nav_hunk("prev") end), "Previous git change")
        map("n", "do", diff_or("do", gs.preview_hunk_inline), "Expand diff hunk")
        map("n", "dO", gs.stage_hunk, "Toggle staged")
        map("n", "dp", diff_or("dp", gs.reset_hunk), "Restore change")
        map("n", "<leader>hb", gs.blame_line, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff file")
        map({ "o", "x" }, "ih", gs.select_hunk, "Git hunk")
      end,
    },
  },
}
