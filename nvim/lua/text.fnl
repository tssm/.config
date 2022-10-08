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
