(local opt vim.opt)
(vim.opt.iskeyword:remove "_")
(set opt.joinspaces false) ; Use only 1 space after a . when joining lines

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
	:indent {:enable true}
	:refactor {
		:highlight_current_scope {:enable true}
		:highlight_definitions {:enable true}}
	:textobjects {
		:move {
			:enable true
			:goto_next_start {"]]" "@function.outer"}
			:goto_next_end {"][" "@function.outer"}
			:goto_previous_start {"[[" "@function.outer"}
			:goto_previous_end {"[]" "@function.outer"}}
		:select {
			:enable true
			:keymaps {
				:af "@function.outer"
				:if "@function.inner"}
			:lookahead true}}})

; Use tree-sitter for setting folds only when a parser is attached
; Fold options are local to window, not buffer, so this may not always behave correctly
((. (require :nvim-treesitter) :define_modules) {
	:fold {
		:attach (fn []
			(set opt.foldmethod :expr)
			(set opt.foldexpr "nvim_treesitter#foldexpr()"))
		:detach (fn []
			(set opt.foldmethod :syntax)
			(set opt.foldexpr ""))
		:enable true
		:is_supported (. (require :nvim-treesitter.query) :has_folds)}})
