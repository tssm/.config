(let
  [call vim.fn
   fnmodify call.fnamemodify
   opt vim.opt
   edit-patch :addp-hunk-edit.diff]

  (fn cursor-position [buftype]
    (if
      (= buftype "")
      (let [position (call.getcurpos)]
        (string.format "%s%i%sשּׂ  %s%i%sﭩ" :%1* (. position 2) :%2* :%1* (. position 3) :%2*))
      (= buftype :quickfix)
      (string.format :%s/%s (call.line :.) (call.line :$))
      ""))

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
      (string.format
        :%%2*%s
        (relative-file-directory bufname))))

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
      (= buftype :help) (.. (fnmodify bufname ":t:r") " help")
      (= buftype :quickfix) vim.w.quickfix_title
      (= buftype :terminal) (terminal-title)
      (= filetype :dap-repl) "Debugger REPL"
      (= filetype :dirvish) (relative-directory bufname)
      (= filetype :gitcommit) "Edit commit message"
      (= filetype :man) (.. (call.substitute bufname "^man://" "" "") " man")
      (= filetype :noice) :Noice
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
      (string.format "%s%s%s%s%s%%#WinSeparator#%%=%s%s"
        ; Left
        (if active?
          ""
          (string.format "%s‹%s›%s" :%1* (call.winnr) :%2*))
        (if active? "" " "); Space between window number and buffer
        (directory bufname buftype filetype)
        (string.format "%s%s%s"
          (if active? :%1* "")
          (buffer bufname buftype filetype)
          (if active? :%2* ""))
        (file-status bufname buftype)
        ; Right
        (if active? "%1*%S%#WinSeparator#%=" "")
        (if active? (cursor-position buftype) "")))))
