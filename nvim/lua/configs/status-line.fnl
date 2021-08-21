(local call vim.fn)
(local fnmodify call.fnamemodify)
(local opt vim.opt)
(local edit-patch :addp-hunk-edit.diff)

(fn cursor-position [buftype]
	(if
		(= buftype "") (let [position (call.getcurpos)]
			(string.format "%i⭆  %i⟱ " (. position 2) (. position 3)))
		(= buftype :quickfix) (string.format :%s/%s (call.line :.) (call.line :$))
		""))

(fn relative-file-directory [path]
	(local cwd (call.getcwd))
	(local directory (fnmodify path ":p:h"))
	(if
		(or (= directory :/) (= directory cwd)) ""
		(string.format :%s/ (call.substitute directory (string.format :%s/ cwd) "" ""))))

(fn relative-directory [path]
	(if
		(= path :/) :/
		(do
			(local normalized (fnmodify path ":p:h"))
			(local cwd (call.getcwd))
			(if
				(= normalized (os.getenv :HOME)) "~"
				(= normalized cwd) "."
				(call.substitute normalized (string.format :%s/ cwd) "" "")))))

(fn directory [bufname buftype filetype]
	(if
		(or
			(= bufname "")
			(not= buftype "")
			(= filetype :gitcommit)
			(= filetype :sqls_output)
			(vim.endswith bufname edit-patch)) ""
		(relative-file-directory bufname)))

(fn file-status [bufname buftype]
	(if
		(or (not= buftype "") (not (opt.modifiable:get))) ""
		(let [
			file (fnmodify bufname ":p")
			read-only (or
				(opt.readonly:get)
				(and (call.filereadable file) (not (call.filewritable file))))
			modified (opt.modified:get)
			icons (.. (if read-only "🔒" "") (if modified "🤔" ""))]
			(if (not= icons "") (.. " " icons) ""))))

(fn terminal-title [bufname]
	(local term-title vim.b.term_title)
	(if
		(= term-title bufname) (call.substitute
			bufname "term:\\/\\/\\(.*\\)\\/\\/\\d\\+:\\ze" "" "")
		term-title))

(fn buffer [bufname buftype filetype]
	(if
		(= buftype :help) (fnmodify bufname ":t:r")
		(= buftype :quickfix) vim.w.quickfix_title
		(= buftype :terminal) (terminal-title bufname)
		(= filetype :dap-repl) "Debugger REPL"
		(= filetype :dirvish) (relative-directory bufname)
		(= filetype :gitcommit) "Edit commit message"
		(= filetype :man) (call.substitute bufname "^man://" "" "")
		(= filetype :sqls_output) "sqls output"
		(= filetype :undotree) :Undotree
		(vim.endswith bufname edit-patch) "Edit patch"
		(vim.startswith bufname :diffpanel_) :Diff
		; This comparison should be the last one because some of the filetypes above are normal
		(= buftype "") (if (= bufname "") "🆕" (fnmodify bufname ":t"))
		""))

(fn status-line [active?]
	(local bufname (call.bufname))
	(local buftype (opt.buftype:get))
	(local filetype (opt.filetype:get))
	(string.format "%s%s%s%s%s%s   %%=%s"
		; Left
		(if active?
			:%#StatusLineNC#
			(string.format "%s❬%s❭%s " :%#StatusLine# (call.winnr) :%#StatusLineNC#))
		(directory bufname buftype filetype)
		(string.format "%s%s%s"
			(if active? :%#StatusLine# "")
			(buffer bufname buftype filetype)
			(if active? :%#StatusLineNC# ""))
		(if (= (opt.buftype:get) :help) " help" "")
		(if (= (opt.buftype:get) :man) " man" "")
		(file-status bufname buftype)
		; Right
		(if active? (.. :%#StatusLine# (cursor-position buftype)) "")))
(set My.status_line status-line)

(local cmd vim.api.nvim_command)
(cmd "augroup SetStatusline")
(cmd "autocmd!")
(cmd "autocmd BufEnter,TermOpen,WinEnter * setlocal statusline=%{%v:lua.My.status_line(v:true)%}")
(cmd "autocmd BufLeave,WinLeave * setlocal statusline=%{%v:lua.My.status_line(v:false)%}")
(cmd "augroup END")
