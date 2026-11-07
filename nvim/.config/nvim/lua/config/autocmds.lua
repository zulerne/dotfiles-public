local group = vim.api.nvim_create_augroup("user_config", { clear = true })
local autocmd = function(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group }, opts))
end

-- Zed: autosave = on_focus_change. Save named, modified file buffers when
-- leaving them or when the terminal loses focus.
autocmd({ "FocusLost", "BufLeave" }, {
  callback = function(args)
    local bo = vim.bo[args.buf]
    if bo.modified and bo.buftype == "" and bo.modifiable and not bo.readonly
      and vim.api.nvim_buf_get_name(args.buf) ~= "" then
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd("silent! update")
      end)
    end
  end,
})

-- Code is typed in English: switch macOS to the ABC layout when entering or
-- leaving Insert mode, and when Neovim regains focus in Normal mode. Uses
-- macism (Brewfile); does nothing where it isn't installed.
if vim.fn.executable("macism") == 1 then
  local function english()
    vim.system({ "macism", "com.apple.keylayout.ABC" })
  end
  autocmd({ "InsertEnter", "InsertLeave" }, { callback = english })
  autocmd("FocusGained", {
    callback = function()
      if vim.api.nvim_get_mode().mode == "n" then
        english()
      end
    end,
  })
end

-- Reload files changed outside Neovim, e.g. by lazygit or Claude Code.
autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Zed: relative line numbers in normal mode, absolute in insert mode.
autocmd("InsertEnter", {
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})
autocmd("InsertLeave", {
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Reopen files at the last cursor position.
autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Equalize splits in every tab page after a resize, staying on the current tab.
autocmd("VimResized", {
  callback = function()
    local tab = vim.api.nvim_get_current_tabpage()
    vim.cmd("tabdo wincmd =")
    vim.api.nvim_set_current_tabpage(tab)
  end,
})

-- Go indents with tabs (set by Neovim's Go ftplugin); show them 4 wide.
-- Python's ftplugin already sets 4-space indents.
autocmd("FileType", {
  pattern = { "go", "gomod", "gowork" },
  callback = function()
    vim.bo.tabstop = 4
  end,
})
