(local cmd vim.api.nvim_command)
(cmd "augroup SignifySetup")
(cmd "autocmd!")
(cmd "autocmd ColorScheme * lua My.signify_signs()")
(cmd "autocmd User SignifyAutocmds lua My.signify_mappings()")
(cmd "augroup END")

(fn set-map [lhs rhs]
	(vim.api.nvim_buf_set_keymap 0 :n lhs rhs {}))

(fn mappings-setup []
	(set-map "]h" "<plug>(signify-next-hunk)")
	(set-map "[h" "<plug>(signify-prev-hunk)")
	(set-map "]H" "9999]h")
	(set-map "[H" "9999[h")
	(set-map :sdf :<cmd>SignifyDiff<cr>)
	(set-map :sdh :<cmd>SignifyHunkDiff<cr>)
	(set-map :su :<cmd>SignifyHunkUndo<cr>))
(set My.signify_mappings mappings-setup)

(local highlights [
	:Add
	:Change
	:ChangeDelete
	:Delete
	:DeleteFirstLine])

(fn signs-setup []
	(each [_ highlight (ipairs highlights)]
		(cmd (string.format "highlight! link SignifySign%s Normal" highlight))))
(set My.signify_signs signs-setup)

(local g vim.g)
(set g.signify_priority 0)
(set g.signify_sign_add "➕")
(set g.signify_sign_change "❗")
(set g.signify_sign_change_delete "‼️")
(set g.signify_sign_delete "➖")
(set g.signify_sign_delete_first_line g.signify_sign_delete)
(set g.signify_sign_show_count false)
