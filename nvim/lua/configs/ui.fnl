(local cmd vim.api.nvim_command)

(cmd "augroup SetUpUi")
(cmd "autocmd!")
(cmd "autocmd ColorScheme * lua My.color_scheme_fix()")
(cmd "augroup END")

; Configure color schemes

(local g vim.g)
(set g.ayucolor :mirage)
(set g.ganymede_solid_background true)
(set g.material_theme_style :palenight)

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
		"CursorLineNr guibg=bg guifg=bg"
		"link EndOfBuffer CursorLineNr"
		"FoldColumn guibg=bg"
		"link Folded FoldColumn"
		"link LineNr FoldColumn"
		"SignColumn guibg=bg"
		"SpecialKey guibg=bg"
		"TermCursorNC guibg=bg guifg=bg"])
	(each [_ highlight (ipairs highlights)]
		(call.execute (string.format "highlight! %s" highlight)))
	(call.execute (string.format "highlight! %s" (vertsplit-highlight))))
(set My.color_scheme_fix fix-color-schemes)

; Set options

(local opt vim.opt)
(set opt.fillchars {:fold " "})
(set opt.guicursor
	"n-v:block,i-c-ci-ve:ver35,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon600-Cursor")
(set opt.list true)
(set opt.listchars {:extends :… :precedes :… :tab "  "})
(set opt.showmatch true)
(set opt.showmode false)
(set opt.showtabline 0)
(set opt.termguicolors true)
