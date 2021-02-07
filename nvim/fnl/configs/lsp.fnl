(module plugins.lsp {:require {
	lspconfig lspconfig
	lsputil	lspconfig/util}})

(def- api vim.api)
(def- cmd api.nvim_command)

(def- set-map [lhs func]
	(api.nvim_buf_set_keymap
		buffer-number
		:n
		lhs
		(string.format "<cmd>lua vim.lsp.buf.%s()<cr>" func)
		{:noremap true :silent true}))

(defn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(cmd "highlight! link LspReferenceRead Search")

	; Buffer mappings

	(set-map "<c-]>" :vim.lsp.buf.definition)
	(set-map :K "require'lspsaga.hover'.render_hover_doc")
	(set-map :<localleader>* :vim.lsp.buf.document_highlight)
	(set-map :<localleader>a :vim.lsp.buf.code_action)
	(set-map :<localleader>r "require'lspsaga.rename'.rename")
	(set-map :<localleader>ds :vim.lsp.buf.document_symbol)
	(set-map :<localleader>ws :vim.lsp.buf.workspace_symbol)
	(set-map :<localleader>s "require'lspsaga.diagnostic'.show_line_diagnostics")
	(set-map "[d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev")
	(set-map "]d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_next")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc))

; Attach configuration to every server

(def-
	lua-server-path
	(string.format "%s/Projects/lua-language-server" (os.getenv :HOME)))

(def- servers {
	:dhall_lsp_server {}
	:hls {}
	:metals {}
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
