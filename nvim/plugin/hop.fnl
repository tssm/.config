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

((. (require :hop) :setup))
