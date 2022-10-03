(local opt vim.opt)
(opt.iskeyword:remove "_")

; Folds
(set opt.foldenable false)
(set opt.foldmethod :syntax)

; Indentation
(set opt.shiftwidth 0) ; Use tabstop as for autoindent
(set opt.tabstop 2) ; Tab width in spaces

; Text wrapping
(set opt.breakat "  ")
(set opt.breakindent true) ; Indent wrapped text
(set opt.linebreak true) ; When wrap is set use the value of breakat
(set opt.wrap false)

; Tree-sitter
((. (require :nvim-treesitter.configs) :setup) {
	:highlight {:enable true :additional_vim_regex_highlighting false}
	:autotag {:enable true}
	:indent {:enable true}
	:textobjects {
		:move {
			:enable true
			:goto_next_start {"]]" "@block.outer"}
			:goto_next_end {"][" "@block.outer"}
			:goto_previous_start {"[[" "@block.outer"}
			:goto_previous_end {"[]" "@block.outer"}}
		:select {
			:enable true
			:keymaps {
				:ab "@block.outer"
				:ib "@block.inner"}
			:lookahead true}}})

(let [
	autocmd vim.api.nvim_create_autocmd
	create-augroup vim.api.nvim_create_augroup
	delete-augroup vim.api.nvim_del_augroup_by_name
	identifier-map :<localleader>hi
	scope-map :<localleader>hs
	map vim.keymap
	query (require :nvim-treesitter.query)]
	((. (require :nvim-treesitter) :define_modules) {
		; Use tree-sitter for setting folds only when a parser is attached
		; Fold options are local to window, not buffer, so this may not always behave correctly
		:fold {
			:attach (fn []
				(set opt.foldmethod :expr)
				(set opt.foldexpr "nvim_treesitter#foldexpr()"))
			:detach (fn []
				(set opt.foldmethod :syntax)
				(set opt.foldexpr ""))
			:enable true
			:is_supported query.has_folds}
		:highlight_identifier {
			:attach (fn [bufnr]
				(local highlight-identifier (require :nvim-treesitter-refactor.highlight_definitions))
				(autocmd :InsertEnter {
					:buffer bufnr
					:callback (fn [] ((. highlight-identifier :clear_usage_highlights) bufnr))
					:group (create-augroup
						(string.format :HighlightIdentifierOnBuffer%d bufnr)
						{:clear true})})
				(map.set
					:n
					identifier-map
					(fn [] ((. highlight-identifier :highlight_usages) bufnr))
					{:buffer bufnr}))
			:detach (fn [bufnr]
				(delete-augroup (string.format :HighlightIdentifierOnBuffer%d bufnr))
				(map.del :n identifier-map {:buffer bufnr}))
			:enable true
			:is_supported query.has_locals}
		:highlight_scope {
			:attach (fn [bufnr]
				(local highlight-scope (require :nvim-treesitter-refactor.highlight_current_scope))
				(autocmd :InsertEnter {
					:buffer bufnr
					:callback (fn [] ((. highlight-scope :clear_highlights) bufnr))
					:group
						(create-augroup (string.format :HighlightScopeOnBuffer%d bufnr)
						{:clear true})})
				(map.set
					:n
					scope-map
					(fn [] ((. highlight-scope :highlight_current_scope) bufnr))
					{:buffer bufnr}))
			:detach (fn [bufnr]
				(delete-augroup (string.format :HighlightScopeOnBuffer%d bufnr))
				(map.del :n scope-map {:buffer bufnr}))
			:enable true
			:is_supported query.has_locals}}))
