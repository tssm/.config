(local dap (require :dap))

(set dap.configurations.scala [
	{:type :scala :request :launch :name :Run :metals {:runType :run}}
	{:type :scala :request :launch :name "Test file" :metals {:runType :testFile}}
	{:type :scala :request :launch :name "Test target" :metals {:runType :testTarget}}])

(vim.fn.sign_define [
	{:name :DapBreakpoint :text "🔴"}
	{:name :DapBreakpointRejected :text "⚫"}
	{:name :DapLog :text "📝"}
	{:name :DapStopped :text "➡️"} ])
