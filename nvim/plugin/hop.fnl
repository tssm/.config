; Mappings

(local mappings {
	:f "Char1AC"
	:F "Char1BC"
	:gl "Line"
	:g/ "Pattern"
	:w "WordAC"
	:b "WordBC"})
(local modes [:n :o :x])

(each [key cmd (pairs mappings)]
	(each [_ mode (ipairs modes)]
		(vim.api.nvim_set_keymap mode key (string.format "<cmd>Hop%s<cr>" cmd) {:noremap true})))

; Color schemes

(local cmd vim.api.nvim_command)

(fn set-colors []
	(each [_ highlight (ipairs ["Cursor Cursor" "NextKey IncSearch" "NextKey1 HopNextKey" "NextKey2 NONE"])]
		(cmd (string.format "highlight! link Hop%s" highlight))))
(set My.hop_colors set-colors)

(cmd "augroup FixHopColors")
(cmd "autocmd!")
(cmd "autocmd ColorScheme * lua My.hop_colors()")
(cmd "augroup END")

((. (require :hop) :setup))
