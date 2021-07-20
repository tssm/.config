(local api vim.api)
(local cmd api.nvim_command)
(local lspconfig (require :lspconfig))
(local telescope (require :telescope.builtin))

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

(fn find-document-symbols []
	(telescope.lsp_document_symbols {:entry_maker symbol-entry-maker}))
(set My.find_document_symbols find-document-symbols)

(fn find-workspace-symbols []
	(telescope.lsp_dynamic_workspace_symbols {:entry_maker symbol-entry-maker}))
(set My.find_workspace_symbols find-workspace-symbols)

(fn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(each [_ reference (ipairs [:Read :Text :Write])]
		(cmd (string.format "highlight! link LspReference%s Search" reference)))

	; Buffer mappings

	(set-map buffer-number "<c-]>" "vim.lsp.buf.definition()")
	(set-map buffer-number :K "require'lspsaga.hover'.render_hover_doc()")
	(set-map buffer-number :<localleader>* "vim.lsp.buf.document_highlight()")
	(set-map buffer-number :<localleader>a "require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_dropdown())")
	(set-map buffer-number :<localleader>r "require'lspsaga.rename'.rename()")
	(set-map buffer-number :<localleader>ds "My.find_document_symbols()")
	(set-map buffer-number :<localleader>ws "My.find_workspace_symbols()")
	(set-map buffer-number :<localleader>s "require'lspsaga.diagnostic'.show_line_diagnostics()")
	(set-map buffer-number "[d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
	(set-map buffer-number "]d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()")
	(set-map buffer-number :<localleader>u "require'telescope.builtin'.lsp_references()")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc))

; Attach configuration to every server

(local
	lua-server-path
	(string.format "%s/Projects/lua-language-server" (os.getenv :HOME)))

(local servers {
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
