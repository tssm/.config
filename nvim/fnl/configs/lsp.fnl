(module plugins.lsp {:require {lspconfig lspconfig}})

(def- api vim.api)
(def- cmd api.nvim_command)

(def- set-map [buffer-number lhs func]
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
	(each [_ reference (ipairs [:Read :Text :Write])]
		(cmd (string.format "highlight! link LspReference%s Search" reference)))

	; Buffer mappings

	(set-map buffer-number "<c-]>" :definition)
	(set-map buffer-number :K :hover)
	(set-map buffer-number :<localleader>* :document_highlight)
	(set-map buffer-number :<localleader>a :code_action)
	(set-map buffer-number :<localleader>r :rename)
	(set-map buffer-number :<localleader>ds :document_symbol)
	(set-map buffer-number :<localleader>ws :workspace_symbol)

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
