(local api vim.api)
(local cmd api.nvim_command)
(local aniseed (require :aniseed.core))
(local lspconfig (require :lspconfig))
(local lsputil (require :lspconfig.util))
(local procedures (require :procedures))
(local telescope (require :telescope.builtin))

(vim.fn.sign_define [
	{:name :LspDiagnosticsSignError :text "🤬"}
	{:name :LspDiagnosticsSignHint :text "☝️"}
	{:name :LspDiagnosticsSignInformation :text "ℹ️"}
	{:name :LspDiagnosticsSignWarning :text "⚠️"}])

(local window-options {
	:pad_bottom 1
	:pad_left 1
	:pad_right 1
	:pad_top 1})
(tset
	vim.lsp.handlers
	:textDocument/hover
	(vim.lsp.with vim.lsp.handlers.hover window-options))
(tset vim.lsp.handlers
	:textDocument/publishDiagnostics
	(vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics {
		:severity_sort true
		:update_in_insert true
		:underline {:severity_limit :Warning}
		:virtual_text {
			:severity_limit :Warning
			:spacing 0}}))
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

(fn symbol-entry-maker [entry]
	(local symbol-name (vim.fn.substitute entry.text "^\\[\\w*\\]" "" ""))
	(local symbol-kind entry.kind)
	{
		:filename (or entry.filename (api.nvim_buf_get_name entry.bufnr))
		:lnum entry.lnum
		:col entry.col
		:display (string.format "%s ▪ %s" symbol-name symbol-kind)
		:ordinal symbol-name
		:symbol_name symbol-name
		:symbol_type symbol-kind
		:value symbol-name})

(fn find-definitions []
	(telescope.lsp_definitions {:entry_maker procedures.quickfix-entry-maker}))
(set My.find_definitions find-definitions)

(fn find-document-symbols []
	(telescope.lsp_document_symbols {:entry_maker symbol-entry-maker}))
(set My.find_document_symbols find-document-symbols)

(fn find-references []
	(telescope.lsp_references {:entry_maker procedures.quickfix-entry-maker}))
(set My.find_references find-references)

(fn find-workspace-symbols []
	(telescope.lsp_dynamic_workspace_symbols {:entry_maker symbol-entry-maker}))
(set My.find_workspace_symbols find-workspace-symbols)

(set My.go_to_diagnostic_options {
	:enable_popup true
	:popup_opts My.show_diagnostic_options
	:severity_limit :Warning})
(set My.show_diagnostic_options (aniseed.merge window-options {:show_header false}))

(fn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd CursorMoved,CursorMovedI * lua require'nvim-lightbulb'.update_lightbulb()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(each [_ reference (ipairs [:Read :Text :Write])]
		(cmd (string.format "highlight! link LspReference%s Search" reference)))

	(each [_ highlight (ipairs [:Error :Warning])]
		(cmd (string.format "highlight! link LspDiagnosticsVirtualText%s %s" highlight highlight)))

	; Buffer mappings

	(set-map buffer-number "<c-]>" "My.find_definitions()")
	(set-map buffer-number :K "vim.lsp.buf.hover()")
	(set-map buffer-number :<localleader>* "vim.lsp.buf.document_highlight()")
	(set-map buffer-number :<localleader>a "require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_dropdown())")
	(set-map buffer-number :<localleader>r "vim.lsp.buf.rename()")
	(set-map buffer-number :<localleader>ds "My.find_document_symbols()")
	(set-map buffer-number :<localleader>ws "My.find_workspace_symbols()")
	(set-map buffer-number :<localleader>sd "vim.lsp.diagnostic.show_line_diagnostics(My.show_diagnostic_options)")
	(set-map buffer-number :<localleader>ss "vim.lsp.buf.signature_help()")
	(set-map buffer-number "[d" "vim.lsp.diagnostic.goto_prev(My.go_to_diagnostic_options)")
	(set-map buffer-number "]d" "vim.lsp.diagnostic.goto_next(My.go_to_diagnostic_options)")
	(set-map buffer-number :<localleader>u "My.find_references()")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc))

; Attach configuration to every server

(local
	lua-server-path
	(string.format "%s/Projects/lua-language-server" (os.getenv :HOME)))

(local servers {
	:ccls {}
	:dhall_lsp_server {}
	:hls {}
	:purescriptls {}
	:rnix {}
	:rust_analyzer {}
	:sqls {
		:on_attach (fn [client buffer-number]
			(set client.resolved_capabilities.execute_command true)
			((. (require :sqls) :setup) {:picker :telescope})
			(set-up client buffer-number))}
	:sumneko_lua {
		:cmd [
			(string.format :%s/bin/macOS/lua-language-server lua-server-path)
			(string.format :%s/main.lua lua-server-path)]
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
