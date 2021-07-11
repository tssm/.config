; Mappings

(local mappings {
	:f "hint_char1({direction = require'hop.hint'.HintDirection.AFTER_CURSOR})"
	:F "hint_char1({direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})"
	:gl "hint_lines()"
	:g/ "hint_patterns()"
	:w "hint_words({direction = require'hop.hint'.HintDirection.AFTER_CURSOR})"
	:b "hint_words({direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})"})
(local modes [:n :o :x])

(each [key cmd (pairs mappings)]
	(each [_ mode (ipairs modes)]
		(vim.api.nvim_set_keymap
			mode
			key
			(string.format "<cmd>lua require'hop'.%s<cr>" cmd)
			{:noremap true})))

; Color schemes

(local cmd vim.api.nvim_command)

(local highlights [
	"NextKey ErrorMsg"
	"NextKey1 HopNextKey"
	"NextKey2 WarningMsg"
	"Unmatched Normal"])

(fn set-colors []
	(each [_ highlight (ipairs highlights)]
		(cmd (string.format "highlight! link Hop%s" highlight))))
(set My.hop_colors set-colors)

(cmd "augroup FixHopColors")
(cmd "autocmd!")
(cmd "autocmd ColorScheme * lua My.hop_colors()")
(cmd "augroup END")
