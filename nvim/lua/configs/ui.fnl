(local cmd vim.api.nvim_command)

(cmd "augroup SetUpUi")
(cmd "autocmd!")
; OptionSet trigger a sandbox error when a modeline is used so silent! is neccessary here ☹️
(cmd "autocmd BufEnter,BufRead,OptionSet * silent! lua My.highlight_too_long()")
(cmd "autocmd ColorScheme * lua My.color_scheme_fix()")
(cmd "augroup END")

; Fix color schemes

(local call vim.fn)

(fn vertsplit-highlight []
	(local status-line-highlight (call.execute "highlight StatusLineNC"))
	(local matchstr call.matchstr)
	(local reversed? (not=
		(matchstr
			status-line-highlight
			"gui=\\(\\w*,\\)*\\(inverse\\|reverse\\)\\(,\\w*\\)*")
		""))
	(local split-color
		(matchstr status-line-highlight (.. :gui (if reversed? :fg :bg) "=\\zs\\S*")))
	(string.format "VertSplit guibg=bg guifg=%s gui=NONE cterm=NONE" split-color))

(fn fix-color-schemes []
	(local highlights [
		"EndOfBuffer guibg=bg guifg=bg"
		"FoldColumn guibg=bg"
		"link Folded FoldColumn"
		"SignColumn guibg=bg"
		"SpecialKey guibg=bg"
		"TermCursorNC guibg=bg guifg=bg"])
	(each [_ highlight (ipairs highlights)]
		(call.execute (string.format "highlight! %s" highlight)))
	(call.execute (string.format "highlight! %s" (vertsplit-highlight))))
(set My.color_scheme_fix fix-color-schemes)

; Highlight lines' excess part according to textwidth

(local opt vim.opt)
(local w vim.w)

(fn highlight-too-long []
	(when (not= w.too_long_match_id nil)
		(pcall #(call.matchdelete w.too_long_match_id)))
	(local buftype (opt.buftype:get))
	(when (or (= buftype "") (= buftype :acwrite))
		(local textwidth (opt.textwidth:get))
		(when (> textwidth 0)
			(local regex (string.format "\\%%>%iv.\\+" textwidth))
			(set w.too_long_match_id (call.matchadd :ColorColumn regex -1)))))
(set My.highlight_too_long highlight-too-long)

; Set options

(set opt.fillchars {:fold " "})
(set opt.guicursor
	"n-v:block,i-c-ci-ve:ver35,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon600-Cursor")
(set opt.list true)
(set opt.listchars {:extends :… :precedes :… :tab "  "})
(set opt.showmatch true)
(set opt.showmode false)
(set opt.showtabline 0)
(set opt.termguicolors true)
