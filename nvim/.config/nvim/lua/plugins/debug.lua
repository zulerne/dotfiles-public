-- Debugger: nvim-dap with Delve for Go (dlv from the Brewfile's go list) and
-- nvim-dap-view as the panel. F-keys follow Zed's debugger defaults; the
-- Space d keys do the same without F-keys.
local function dap(fn, ...)
  local args = { ... }
  return function()
    require("dap")[fn](unpack(args))
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "leoluz/nvim-dap-go", opts = {} },
      { "igorlfs/nvim-dap-view", version = "1.*", opts = { auto_toggle = true } },
    },
    keys = {
      { "<F4>", dap("continue"), desc = "Debug: start" },
      { "<F5>", dap("continue"), desc = "Debug: continue" },
      { "<S-F5>", dap("terminate"), desc = "Debug: stop" },
      { "<F6>", dap("pause"), desc = "Debug: pause" },
      { "<F9>", dap("toggle_breakpoint"), desc = "Debug: toggle breakpoint" },
      {
        "<S-F9>",
        function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end,
        desc = "Debug: log breakpoint",
      },
      { "<F10>", dap("step_over"), desc = "Debug: step over" },
      { "<F7>", dap("step_over"), desc = "Debug: step over" },
      { "<F11>", dap("step_into"), desc = "Debug: step into" },
      { "<S-F11>", dap("step_out"), desc = "Debug: step out" },

      { "<leader>dd", dap("continue"), desc = "Start / continue" },
      { "<leader>db", dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
        desc = "Conditional breakpoint",
      },
      { "<leader>dn", dap("step_over"), desc = "Step over" },
      { "<leader>di", dap("step_into"), desc = "Step into" },
      { "<leader>do", dap("step_out"), desc = "Step out" },
      { "<leader>dc", dap("run_to_cursor"), desc = "Run to cursor" },
      { "<leader>dq", dap("terminate"), desc = "Stop" },
      { "<leader>dr", dap("run_last"), desc = "Rerun last session" },
      { "<leader>dt", function() require("dap-go").debug_test() end, desc = "Debug test under cursor" },
      { "<leader>dT", function() require("dap-go").debug_last_test() end, desc = "Debug last test" },
      { "<leader>dv", "<Cmd>DapViewToggle<CR>", desc = "Toggle debug panel" },
    },
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
    end,
  },
}
