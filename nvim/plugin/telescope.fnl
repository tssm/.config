(local aniseed (require :aniseed.core))
(local pickers (require :telescope.builtin))
(local actions (require :telescope.actions))
(local actions-state (require :telescope.actions.state))
(local procedures (require :procedures))
(local telescope (require :telescope))

; Custom actions

(fn change-directory? [directory]
	(when (and
		(= (vim.fn.isdirectory directory) 1)
		(= (vim.fn.getcwd) (os.getenv :HOME)))
			(vim.cmd (.. "cd " directory))))

(fn create-file []
	(procedures.create-file (aniseed.first (actions-state.get_selected_entry))))

(fn edit-command []
	(vim.call :feedkeys (.. ":" (aniseed.first (actions-state.get_selected_entry)))))

(fn edit-first [prompt-buffer-number]
	(local
		prompt-title
		(. (actions-state.get_current_picker prompt-buffer-number) :prompt_title))
	(actions.close prompt-buffer-number)
	(match prompt-title
		"Find Files" (create-file)
		"Oldfiles" (create-file)))

(fn open-directory [prompt-buffer-number]
	(actions.close prompt-buffer-number)
	(vim.cmd (.. "edit "
		(vim.fn.fnamemodify
			(aniseed.first (actions-state.get_selected_entry))
			":h"))))

(fn open-file [prompt-buffer-number]
	(actions.select_default prompt-buffer-number)
	(change-directory? (aniseed.first (actions-state.get_selected_entry))))

(fn open-terminal [prompt-buffer-number]
	(local selected-entry (aniseed.first (actions-state.get_selected_entry)))
	(local directory (if (= (vim.fn.isdirectory selected-entry) 1)
		selected-entry
		(vim.fn.fnamemodify selected-entry ":h")))
	(actions.close prompt-buffer-number)
	; termopen destroys the current buffer and cannot be called from a modified
	; one so before calling it a new empty and unchanged buffer is created
	(vim.cmd :enew)
	(vim.fn.termopen (os.getenv :SHELL) {:cwd directory})
	(change-directory? directory))

(telescope.setup {:defaults {
	:dynamic_preview_title true
	:layout_config {:prompt_position :top}
	:mappings {:i {
		:<cr> open-file
		:<c-e> edit-first
		:<c-j> actions.move_selection_next
		:<c-k> actions.move_selection_previous
		:<c-n> actions.cycle_history_next
		:<c-p> actions.cycle_history_prev
		:<c-q> actions.smart_send_to_qflist
		:<c-s> actions.select_horizontal
		:<c-x> false
		:<c-z> open-terminal
		:<c-_> open-directory}}
	:path_display {:truncate true}
	:sorting_strategy :ascending
	:winblend 10}})

; Custom finders

(fn add-pijulignore? [tbl]
	; Both fd and rg rise an error if --file-ignore doesn't exist so it must be
	; added conditionally
	(when (= (vim.fn.filereadable :.pijulignore) true)
		(table.insert tbl :--file-ignore=.pijulignore))
	tbl)

(fn find-files []
	(if (= (vim.fn.getcwd) (os.getenv :HOME))
		(pickers.find_files {
			:find_command [:fd :--color=never :--follow :--max-depth=1 :--type=d]
			:search_dirs [:. :Projects]})
		(pickers.find_files {
			:find_command
				(add-pijulignore?
				[:fd :--color=never :--exclude=*.enc :--hidden :--type=f])
			:search_dirs [:.]})))

(fn grep []
	(if (= (vim.fn.getcwd) (os.getenv :HOME))
		(print "Do not live grep from ~")
		(let [grep-command [:rg :--vimgrep]]
			(add-pijulignore? grep-command)
			(pickers.live_grep {:vimgrep_arguments grep-command}))))

; Mappings

(fn set-map [lhs rhs]
	(vim.api.nvim_set_keymap
		:n
		lhs
		(string.format "<cmd>lua %s<cr>" rhs)
		{:noremap true :silent true}))

(set-map :<leader>b "require'telescope.builtin'.buffers()")

(set-map :<leader>c "require'telescope.builtin'.command_history()")

(set My.find_files find-files)
(set-map :<leader>f "My.find_files()")

(set My.grep grep)
(set-map :<leader>g "My.grep()")

(set-map :<leader>h "require'telescope.builtin'.help_tags()")

(set-map :<leader>o "require'telescope.builtin'.oldfiles()")

(set-map :<leader>q "require'telescope.builtin'.quickfix()")

(set-map :z= "require'telescope.builtin'.spell_suggest(require'telescope.themes'.get_dropdown())")
