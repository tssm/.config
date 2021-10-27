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

; Forward 1 char motion after an operator is a special case that requires v to make the it inclusive
(vim.api.nvim_set_keymap :o :f "v<cmd>:HopChar1AC<cr>" {:noremap true})

((. (require :hop) :setup))
