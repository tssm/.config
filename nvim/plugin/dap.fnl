(local dap (require :dap))

(vim.fn.sign_define [
	{:name :DapBreakpoint :text "🔴"}
	{:name :DapBreakpointRejected :text "⚫"}
	{:name :DapLog :text "📝"}
	{:name :DapStopped :text "➡️"} ])
