(local api vim.api)
(local cmd api.nvim_command)
(local lspconfig (require :lspconfig))
(local lsputil (require :lspconfig.util))
(local procedures (require :procedures))
(local telescope (require :telescope.builtin))

(vim.fn.sign_define [
	{:name :LspDiagnosticsSignError :text "🚫"}
	{:name :LspDiagnosticsSignHint :text "☝️"}
	{:name :LspDiagnosticsSignInformation :text "ℹ️"}
	{:name :LspDiagnosticsSignWarning :text "⚠️"}])

(tset vim.lsp.handlers
	:textDocument/publishDiagnostics
	(vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics {
		:severity_sort true
		:update_in_insert true
		:underline {:severity_limit :Warning}
		:virtual_text {
			:severity_limit :Warning
			:spacing 0}}))

(fn set-map [lhs func]
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
		:filename (or entry.filename (vim.api.nvim_buf_get_name entry.bufnr))
		:lnum entry.lnum
		:col entry.col
		:display (string.format "%s ▪ %s" symbol-name symbol-kind)
		:ordinal symbol-name
		:symbol_name symbol-name
		:symbol_type symbol-kind
		:value symbol-name})

(fn find-document-symbols []
	(telescope.lsp_document_symbols {:entry_maker symbol-entry-maker}))
(set My.find_document_symbols find-document-symbols)

(fn find-references []
	(telescope.lsp_references {:entry_maker procedures.quickfix-entry-maker}))
(set My.find_references find-references)

(fn find-workspace-symbols []
	(telescope.lsp_dynamic_workspace_symbols {:entry_maker symbol-entry-maker}))
(set My.find_workspace_symbols find-workspace-symbols)

(fn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(cmd "highlight! link LspReferenceRead Search")

	; Buffer mappings

	(set-map "<c-]>" "vim.lsp.buf.definition()")
	(set-map :K "vim.lsp.buf.hover()")
	(set-map :<localleader>* "vim.lsp.buf.document_highlight()")
	(set-map :<localleader>a "require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_dropdown())")
	(set-map :<localleader>r "vim.lsp.buf.rename()")
	(set-map :<localleader>ds "My.find_document_symbols()")
	(set-map :<localleader>ws "My.find_workspace_symbols()")

	(set My.show_diagnostic_options {:show_header false})
	(set-map :<localleader>s "vim.lsp.diagnostic.show_line_diagnostics(My.show_diagnostic_options)")

	(set My.go_to_diagnostic_options {
		:enable_popup true
		:popup_opts My.show_diagnostic_options
		:severity_limit :Warning})
	(set-map "[d" "vim.lsp.diagnostic.goto_prev(My.go_to_diagnostic_options)")
	(set-map "]d" "vim.lsp.diagnostic.goto_next(My.go_to_diagnostic_options)")

	(set-map :<localleader>u "My.find_references()")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc)

	; Lightbulb

	(cmd "autocmd CursorMoved,CursorMovedI * lua require'nvim-lightbulb'.update_lightbulb()"))

; Attach configuration to every server

(local
	lua-server-path
	(string.format "%s/Projects/lua-language-server" (os.getenv :HOME)))

(local servers {
	:ccls {}
	:dhall_lsp_server {}
	:hls {}
	:purescriptls {}
	:rls {}
	:rnix {}
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
	(tset opts :on_attach set-up)
	(server.setup opts))

; Metals

(set vim.g.metals_use_global_executable true)
(local metals-config {
	:on_attach (fn []
		(set-up)
		((. (require :metals) :setup_dap)))
	:settings {
		:showImplicitArguments true
		:showImplicitConversionsAndClasses true
		:showInferredType true}})
(set My.metals_config metals-config)
(cmd "autocmd FileType sbt,scala lua require'metals'.initialize_or_attach(My.metals_config)")
