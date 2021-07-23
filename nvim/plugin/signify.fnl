(local cmd vim.api.nvim_command)
(cmd "augroup SignifySetup")
(cmd "autocmd!")
(cmd "autocmd User SignifyAutocmds lua My.signify_mappings()")
(cmd "augroup END")

(fn set-map [lhs rhs]
	(vim.api.nvim_buf_set_keymap 0 :n lhs rhs {}))
(fn set-up-signify-mappings []
	(set-map "]h" "<plug>(signify-next-hunk)")
	(set-map "[h" "<plug>(signify-prev-hunk)")
	(set-map "]H" "9999]h")
	(set-map "[H" "9999[h")
	(set-map :sdf :<cmd>SignifyDiff<cr>)
	(set-map :sdh :<cmd>SignifyHunkDiff<cr>)
	(set-map :su :<cmd>SignifyHunkUndo<cr>))
(set My.signify_mappings set-up-signify-mappings)

(set vim.g.signify_priority 0)
