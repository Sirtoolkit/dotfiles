return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    -- Disable status messages to prevent repeated notifications
    vim.g.copilot_echo_status = 0
    vim.g.copilot_no_status_messages = 1
  end,
}
