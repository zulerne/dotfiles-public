local opt = vim.opt

-- No remote plugins in Python, Node.js, Perl or Ruby are used.
for _, provider in ipairs({ "python3", "node", "perl", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Follow the macOS appearance at startup (Catppuccin Latte/Mocha).
local appearance = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
vim.o.background = appearance:match("Dark") and "dark" or "light"

opt.clipboard = "unnamedplus" -- Zed: vim.use_system_clipboard = always
opt.number = true
opt.relativenumber = true -- absolute in insert mode, see autocmds (Zed: toggle_relative_line_numbers)
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8

opt.wrap = true -- Zed: soft_wrap = editor_width
opt.linebreak = true
opt.breakindent = true

opt.ignorecase = true -- Zed: use_smartcase_find
opt.smartcase = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.swapfile = false
opt.autoread = true
opt.updatetime = 250
opt.confirm = true -- ask to save instead of failing on :q with changes
opt.showmode = false -- lualine shows the mode
opt.winborder = "rounded"
opt.fillchars = { eob = " " }

-- Folds from Tree-sitter, all open by default.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { current_line = true },
  float = { source = true },
})
