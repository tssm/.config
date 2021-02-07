(module plugins.lsp {:require {lspconfig lspconfig}})

(def- api vim.api)
(def- cmd api.nvim_command)

(def- set-map [buffer-number lhs func]
	(api.nvim_buf_set_keymap
		buffer-number
		:n
		lhs
		(string.format "<cmd>lua %s()<cr>" func)
		{:noremap true :silent true}))

(defn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(each [_ reference (ipairs [:Read :Text :Write])]
		(cmd (string.format "highlight! link LspReference%s Search" reference)))

	; Buffer mappings

	(set-map buffer-number "<c-]>" :vim.lsp.buf.definition)
	(set-map buffer-number :K "require'lspsaga.hover'.render_hover_doc")
	(set-map buffer-number :<localleader>* :vim.lsp.buf.document_highlight)
	(set-map buffer-number :<localleader>a :vim.lsp.buf.code_action)
	(set-map buffer-number :<localleader>r "require'lspsaga.rename'.rename")
	(set-map buffer-number :<localleader>ds :vim.lsp.buf.document_symbol)
	(set-map buffer-number :<localleader>ws :vim.lsp.buf.workspace_symbol)
	(set-map buffer-number :<localleader>s "require'lspsaga.diagnostic'.show_line_diagnostics")
	(set-map buffer-number "[d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev")
	(set-map buffer-number "]d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_next")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc))

; Attach configuration to every server

(def-
	lua-server-path
	(string.format "%s/Projects/lua-language-server" (os.getenv :HOME)))

(def- servers {
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
