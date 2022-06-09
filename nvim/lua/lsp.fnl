(local api vim.api)
(local cmd api.nvim_command)
(local aniseed (require :aniseed.core))
(local lspconfig (require :lspconfig))

(vim.diagnostic.config {
	:float {:header false}
	:severity_sort true
	:update_in_insert true
	:underline {:severity {:min vim.diagnostic.severity.WARN}}
	:virtual_text {
		:severity {:min vim.diagnostic.severity.WARN}
		:spacing 0}})

(vim.fn.sign_define [
	{:name :DiagnosticSignError :text "" :texthl :DiagnosticSignError}
	{:name :DiagnosticSignHint :text "" :texthl :DiagnosticSignHint}
	{:name :DiagnosticSignInfo :text "" :texthl :DiagnosticSignInfo}
	{:name :DiagnosticSignWarn :text "" :texthl :DiagnosticSignWarn}
	{:name :LightBulbSign :text "" :texthl :DiagnosticSignWarn}])

(local window-options {:pad_bottom 1 :pad_top 1})
(tset
	vim.lsp.handlers
	:textDocument/hover
	(vim.lsp.with vim.lsp.handlers.hover window-options))
(tset
	vim.lsp.handlers
	:textDocument/signatureHelp
	(vim.lsp.with vim.lsp.handlers.signature_help window-options))

(fn set-map [buffer-number lhs func]
	(api.nvim_buf_set_keymap
		buffer-number
		:n
		lhs
		(string.format "<cmd>lua %s<cr>" func)
		{:noremap true :silent true}))

(set My.go_to_diagnostic_options {
	:float window-options
	:severity {:min vim.diagnostic.severity.WARN}})
(set My.show_diagnostic_options (aniseed.merge window-options {:scope :line}))

(fn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd CursorMoved,CursorMovedI * lua require'nvim-lightbulb'.update_lightbulb()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(each [_ reference (ipairs [:Read :Text :Write])]
		(cmd (string.format "highlight! link LspReference%s Search" reference)))

	; Buffer mappings

	(set-map buffer-number "<c-]>" "require'telescope.builtin'.lsp_definitions()")
	(set-map buffer-number :K "vim.lsp.buf.hover()")
	(set-map buffer-number :<localleader>h "vim.lsp.buf.document_highlight()")
	(set-map buffer-number :<localleader>a "vim.lsp.buf.code_action()")
	(set-map buffer-number :<localleader>r "vim.lsp.buf.rename()")
	(set-map buffer-number :<localleader>ds "require'telescope.builtin'.lsp_document_symbols()")
	(set-map buffer-number :<localleader>ws "require'telescope.builtin'.lsp_dynamic_workspace_symbols()")
	(set-map buffer-number :<localleader>sd "vim.diagnostic.open_float(0, My.show_diagnostic_options)")
	(set-map buffer-number :<localleader>ss "vim.lsp.buf.signature_help()")
	(set-map buffer-number "[d" "vim.diagnostic.goto_prev(My.go_to_diagnostic_options)")
	(set-map buffer-number "]d" "vim.diagnostic.goto_next(My.go_to_diagnostic_options)")
	(set-map buffer-number :<localleader>u "require'telescope.builtin'.lsp_references()")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc))

; Attach configuration to every server

(local servers {
	:ccls {}
	:dhall_lsp_server {}
	:hls {}
	:purescriptls {}
	:rnix {}
	:rust_analyzer {}
	:sqls {
		:on_attach (fn [client buffer-number]
			((. (require :sqls) :on_attach) client buffer-number)
			(set-up client buffer-number))}
	:sumneko_lua {
		:settings {
			:Lua {
				:diagnostics {:globals [:vim]}
				:runtime {
					:path (vim.split package.path ";")
					:version :LuaJIT}
				:workspace {
					:library {
						"vim.fn.expand('$VIMRUNTIME/lua')" true
						"vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')" true}}}}}})

(each [name opts (pairs servers)]
	(local server (. lspconfig name))
	(when (= opts.on_attach nil)
		(tset opts :on_attach set-up))
	(server.setup opts))
