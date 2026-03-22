-- ==============================================
-- THEME (Catppuccin auto light/dark)
-- ==============================================

-- Detect macOS appearance
local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
if handle then
  local result = handle:read("*l")
  handle:close()
  vim.o.background = (result == "Dark") and "dark" or "light"
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
})

-- ==============================================
-- OPTIONS
-- ==============================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

-- ==============================================
-- KEYBINDINGS (mirrored from Zed)
-- ==============================================

-- jj / jk → exit insert mode
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')

-- U → redo
vim.keymap.set('n', 'U', '<C-r>')

-- H / L → first non-whitespace / end of line
vim.keymap.set({ 'n', 'v' }, 'H', '^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')

-- Ctrl-j / Ctrl-k → half-page scroll down / up
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<C-d>zz')
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<C-u>zz')
