-- General keymaps. Plugin keymaps live next to their plugin in lua/plugins/;
-- LSP keymaps are in lua/plugins/lsp.lua.
local map = vim.keymap.set

-- Space is the leader key only.
map({ "n", "x" }, "<Space>", "<Nop>")

map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<Esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

-- Zed (vim-indentwise): [- ]- lesser indent, [+ ]+ greater indent,
-- [= ]= same indent; previous / next non-blank line, with a count.
local function indent_jump(dir, cmp)
  return function()
    local lnum = vim.fn.line(".")
    local last = vim.fn.line("$")
    for _ = 1, vim.v.count1 do -- a count repeats the jump, like pressing it again
      local base = vim.fn.indent(lnum)
      local l = lnum + dir
      while l >= 1 and l <= last do
        if vim.fn.getline(l):match("%S") and cmp(vim.fn.indent(l), base) then
          break
        end
        l = l + dir
      end
      if l < 1 or l > last then
        break
      end
      lnum = l
    end
    if lnum ~= vim.fn.line(".") then
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
      vim.cmd("normal! ^")
    end
  end
end
local less = function(i, base) return i < base end
local more = function(i, base) return i > base end
local same = function(i, base) return i == base end
for lhs, spec in pairs({
  ["[-"] = { -1, less, "Previous line with less indent" },
  ["]-"] = { 1, less, "Next line with less indent" },
  ["[+"] = { -1, more, "Previous line with more indent" },
  ["]+"] = { 1, more, "Next line with more indent" },
  ["[="] = { -1, same, "Previous line with the same indent" },
  ["]="] = { 1, same, "Next line with the same indent" },
}) do
  map({ "n", "x", "o" }, lhs, indent_jump(spec[1], spec[2]), { desc = spec[3] })
end

-- Zed: space w / space q.
map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
map("n", "<leader>Q", "<Cmd>qa<CR>", { desc = "Quit Neovim" })

-- Zed: space r saves and runs a task, in a terminal split.
-- * Inside a Go TestXxx / BenchmarkXxx / FuzzXxx / ExampleXxx: runs that one.
-- * In any other file of a Go `package main`: go run . for that package.
-- * Otherwise reruns the last command; the first time it asks, guessing from
--   the project (Taskfile -> task, Go -> go run ., Python -> uv run file).
-- Go commands run in the file's package directory, others in the git root.
-- Space R edits the command before running it.
local last, last_terminal -- last = { cmd = string, cwd = string }

local function default_cwd()
  if vim.bo.filetype == "go" then
    return vim.fn.expand("%:p:h")
  end
  return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

local function guess_command()
  local root = vim.fs.root(0, { "Taskfile.yml", "Taskfile.yaml" })
  if root then
    return "task"
  elseif vim.bo.filetype == "go" then
    return "go run ."
  elseif vim.bo.filetype == "python" then
    return "uv run " .. vim.fn.expand("%:p")
  end
  return ""
end

-- The Go test, benchmark, fuzz test or example around the cursor, as a command.
local function go_test_command()
  if vim.bo.filetype ~= "go" or not vim.fn.expand("%:t"):match("_test%.go$") then
    return nil
  end
  local node = vim.treesitter.get_node()
  while node and node:type() ~= "function_declaration" do
    node = node:parent()
  end
  local name_node = node and node:field("name")[1]
  local name = name_node and vim.treesitter.get_node_text(name_node, 0)
  if not name then
    return "go test ."
  elseif name:match("^Benchmark") then
    return ("go test -run '^$' -bench '^%s$' ."):format(name)
  elseif name:match("^Test") or name:match("^Fuzz") or name:match("^Example") then
    return ("go test -run '^%s$' -v ."):format(name)
  end
  return "go test ."
end

-- go run . when the current Go file belongs to package main.
local function go_main_command()
  if vim.bo.filetype ~= "go" then
    return nil
  end
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 200, false)) do
    local pkg = line:match("^package%s+([%w_]+)")
    if pkg then
      return pkg == "main" and "go run ." or nil
    end
  end
end

-- The command for where the cursor is, if it can be told from the code.
local function context_command()
  return go_test_command() or go_main_command()
end

local function run(cmd, cwd)
  last = { cmd = cmd, cwd = cwd }
  if last_terminal and last_terminal:buf_valid() then
    last_terminal:close()
  end
  -- A bottom panel, like Zed's terminal; q closes it.
  last_terminal = Snacks.terminal.open(cmd, {
    cwd = cwd,
    interactive = false,
    win = { position = "bottom", height = 0.3 },
  })
end

local function ask_and_run()
  local cwd = default_cwd()
  local default = context_command() or (last and last.cmd) or guess_command()
  vim.ui.input({ prompt = "Run in " .. vim.fn.fnamemodify(cwd, ":~") .. ": ", default = default }, function(cmd)
    if cmd and cmd ~= "" then
      run(cmd, cwd)
    end
  end)
end

map("n", "<leader>r", function()
  vim.cmd("silent! wall")
  local cmd = context_command()
  if cmd then
    run(cmd, default_cwd())
  elseif last then
    run(last.cmd, last.cwd)
  else
    ask_and_run()
  end
end, { desc = "Save and run" })
map("n", "<leader>R", function()
  vim.cmd("silent! wall")
  ask_and_run()
end, { desc = "Save and run (edit command)" })
