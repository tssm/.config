(local cmd vim.api.nvim_command)

(cmd "augroup SetUpUi")
(cmd "autocmd!")
(cmd "autocmd BufEnter,BufRead * lua My.highlight_too_long() My.highlight_trailing_whitespace() My.highlight_wrong_indentation()")
; OptionSet trigger a sandbox error when a modeline is used so silent! is neccessary here ☹️
(cmd "autocmd OptionSet * silent! lua My.highlight_too_long() My.highlight_wrong_indentation()")
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

(local trailing-whitespace-regex (string.format
	"[%s]\\+\\%%#\\@<!$"
	(call.join [
		:\u0009 ; tab
		:\u000a ; line feed
		:\u000b ; line tabulation
		:\u000c ; form feed
		:\u000d ; carriage return
		:\u0020 ; space
		:\u0085 ; next line
		:\u00a0 ; no-break space
		:\u1680 ; ogham space mark
		:\u2000 ; en quad
		:\u2001 ; em quad
		:\u2002 ; en space
		:\u2003 ; em space
		:\u2004 ; three-per-em space
		:\u2005 ; four-per-em space
		:\u2006 ; six-per-em space
		:\u2007 ; figure space
		:\u2008 ; punctuation space
		:\u2009 ; thin space
		:\u200a ; hair space
		:\u2028 ; line separation
		:\u2029 ; paragraph separation
		:\u202f ; narrow no-break space
		:\u205f ; medium mathematical space
		:\u3000] ""))) ; ideographic space

(fn highlight-trailing-whitespace []
	(when (not= w.trailing_whitespace_match_id nil)
		(pcall #(call.matchdelete w.trailing_whitespace_match_id)))
	(local buftype (opt.buftype:get))
	(when (or (= buftype "") (= buftype :acwrite))
		(set w.trailing_whitespace_match_id
			(call.matchadd :ColorColumn trailing-whitespace-regex))))
(set My.highlight_trailing_whitespace highlight-trailing-whitespace)

(local spaces-indentation "^\\ \\ *")
(local tabs-indentation "^\\t\\t*")
(fn highlight-wrong-indentation []
	(when (not= w.wrong_indentation_match_id nil)
		(pcall #(call.matchdelete w.wrong_indentation_match_id)))
	(local buftype (opt.buftype:get))
	(when (or (= buftype "") (= buftype :acwrite))
		(local wrong-indentation-regex
			(if (opt.expandtab:get) tabs-indentation
				(if (or (= (opt.softtabstop:get) 0) (= (opt.softtabstop:get) (opt.tabstop:get)))
					(.. spaces-indentation "\\|" tabs-indentation "\\zs\\ \\+")
					spaces-indentation)))
		(set w.wrong_indentation_match_id
			(call.matchadd :ColorColumn wrong-indentation-regex))))
(set My.highlight_wrong_indentation highlight-wrong-indentation)

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
