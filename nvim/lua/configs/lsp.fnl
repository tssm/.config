(local api vim.api)
(local cmd api.nvim_command)
(local lspconfig (require :lspconfig))
(local lsputil (require :lspconfig.util))

(fn set-map [lhs func]
	(api.nvim_buf_set_keymap
		buffer-number
		:n
		lhs
		(string.format "<cmd>lua %s<cr>" func)
		{:noremap true :silent true}))

(fn set-up [client buffer-number]
	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")
	(cmd "highlight! link LspReferenceRead Search")

	; Buffer mappings

	(set-map "<c-]>" "vim.lsp.buf.definition()")
	(set-map :K "require'lspsaga.hover'.render_hover_doc()")
	(set-map :<localleader>* "vim.lsp.buf.document_highlight()")
	(set-map :<localleader>a "require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_dropdown())")
	(set-map :<localleader>r "require'lspsaga.rename'.rename()")
	(set-map :<localleader>ds "require'telescope.builtin'.lsp_document_symbols()")
	(set-map :<localleader>ws "require'telescope.builtin'.lsp_dynamic_workspace_symbols()")
	(set-map :<localleader>s "require'lspsaga.diagnostic'.show_line_diagnostics()")
	(set-map "[d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
	(set-map "]d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()")
	(set-map :<localleader>u "require'telescope.builtin'.lsp_references()")

	; Buffer options

	(api.nvim_buf_set_option buffer-number :omnifunc :v:lua.vim.lsp.omnifunc))

; Attach configuration to every server

(local
	lua-server-path
	(string.format "%s/Projects/lua-language-server" (os.getenv :HOME)))

(local servers {
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
