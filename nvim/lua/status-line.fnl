(let
  [call vim.fn
   fnmodify call.fnamemodify
   opt vim.opt
   edit-patch :addp-hunk-edit.diff]

  (fn cursor-position [buftype]
    ; Position 'showcmd' in the middle for normal buffers and to the right on all the others
    (string.format "%%S%s"
      (if
        (= buftype "")
        (let [position (call.getcurpos)]
          (string.format "%%=%s%i%sשּׂ  %s%i%sﭩ " :%#StatusLine# (. position 2) :%#StatusLineNC# :%#StatusLine# (. position 3) :%#StatusLineNC#))
        (= buftype :quickfix)
        (string.format :%s/%s (call.line :.) (call.line :$))
        "")))

  (fn relative-file-directory [path]
    (let
      [cwd (call.getcwd)
       directory (fnmodify path ":p:h")]
      (if
        (or (= directory :/) (= directory cwd)) ""
        (string.format :%s/ (call.substitute directory (string.format :%s/ cwd) "" "")))))

  (fn relative-directory [path]
    (if
      (= path :/) :/
      (let
        [normalized (fnmodify path ":p:h")
         cwd (call.getcwd)]
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
        (vim.endswith bufname edit-patch)) ""
      (relative-file-directory bufname)))

  (fn file-status [bufname buftype]
    (if
      (or (not= buftype "") (not (opt.modifiable:get))) ""
      (let
        [file (fnmodify bufname ":p")
         read-only
           (or
             (opt.readonly:get)
             (and (call.filereadable file) (not (call.filewritable file))))
         modified (opt.modified:get)
         icons (.. (if read-only "🔒" "") (if modified "🤔" ""))]
        (if (not= icons "") (.. " " icons) ""))))

  (fn terminal-title []
    (let [term-title vim.b.term_title]
      (if (vim.startswith term-title "term://")
        (call.substitute term-title "term:\\/\\/\\(.*\\)\\/\\/\\d\\+:\\ze" "" "")
        term-title)))

  (fn buffer [bufname buftype filetype]
    (if
      (= buftype :help) (fnmodify bufname ":t:r")
      (= buftype :quickfix) vim.w.quickfix_title
      (= buftype :terminal) (terminal-title)
      (= filetype :dap-repl) "Debugger REPL"
      (= filetype :dirvish) (relative-directory bufname)
      (= filetype :fugitive) "Git status"
      (= filetype :gitcommit) "Edit commit message"
      (= filetype :man) (call.substitute bufname "^man://" "" "")
      (= filetype :octo) (call.substitute bufname "^octo://" "" "")
      (= filetype :undotree) :Undotree
      (vim.endswith bufname edit-patch) "Edit patch"
      (vim.startswith bufname :diffpanel_) :Diff
      ; This comparison should be the last one because some of the filetypes above are normal
      (= buftype "") (if (= bufname "") "🆕" (fnmodify bufname ":t"))
      ""))

  (fn [active?]
    (let
      [bufname (call.bufname)
       buftype (opt.buftype:get)
       filetype (opt.filetype:get)]
      (string.format "%s%s%s%s%s%s%%=%s"
        ; Left
        (if active?
          :%#StatusLineNC#
          (string.format "%s‹%s›%s " :%#StatusLine# (call.winnr) :%#StatusLineNC#))
        (directory bufname buftype filetype)
        (string.format "%s%s%s"
          (if active? :%#StatusLine# "")
          (buffer bufname buftype filetype)
          (if active? :%#StatusLineNC# ""))
        (if (= (opt.buftype:get) :help) " help" "")
        (if (= (opt.buftype:get) :man) " man" "")
        (file-status bufname buftype)
        ; Right
        (if active? (cursor-position buftype) "")))))
