(let
  [cmd vim.cmd
   f vim.fn
   fzf (require :fzf-lua)
   fzf-actions (require :fzf-lua.actions)
   fzf-path (require :fzf-lua.path)
   rg-opts "--color always --column --glob !.git --glob !.pijul --hidden --no-heading --no-require-git --smart-case --trim"
   {: delete-buffer-and-file} (require :reflex)
   {: create-file} (require :procedures)

   at-home? (fn [] (= (f.getcwd) (fzf-path.HOME)))
   cd?
     (fn [directory]
       (when (at-home?) (cmd (string.format "cd %s" directory))))
   path-from-selection (fn [selected] (. (fzf-path.entry_to_file (. selected 1)) :path))
   parent (fn [path] (f.fnamemodify path ":h"))

   create-from-selected
     (fn [selected] (create-file (path-from-selection selected)))

   delete-file
     (fn [selected opts]
       (delete-buffer-and-file (path-from-selection selected))
       (fzf-actions.resume selected opts))

   open-file
     (fn [selected opts]
       (fzf-actions.file_edit_or_qf selected opts)
       (cd? (path-from-selection selected)))

   open-terminal
     (fn [selected]
       (let
         [path (path-from-selection selected)
          directory
           (if
             (= (f.isdirectory path) 1) path
             (parent path))]

         ; termopen destroys the current buffer and cannot be called from a modified
         ; one, so before calling it an empty and unchanged one is created
         (cmd :enew)
         (f.termopen (os.getenv :SHELL) {:cwd directory})
         (cd? directory)))

   show-directory
     (fn [selected] (cmd (string.format "edit %s" (parent (path-from-selection selected)))))]

  (fzf.setup
    {:actions
     {:files
      {:default open-file
       :ctrl-e create-from-selected
       :ctrl-s fzf-actions.file_split
       :ctrl-t fzf-actions.file_tabedit
       :ctrl-v fzf-actions.file_vsplit
       :ctrl-x delete-file
       :ctrl-z open-terminal
       :ctrl-_ show-directory}}
     :buffers
     {:fzf_opts {:--delimiter fzf.utils.nbsp :--with-nth :-2..}
      :ignore_current_buffer true}
     :files {:git_icons false}
     :fzf_opts
     {:--ansi ""
      :--border :none
      :--color "bg+:-1,fg+:white" ; Removes the gutter while keeping the text visible
      :--cycle ""
      :--ellipsis :…
      :--info :inline
      :--height :100%
      :--layout :reverse
      :--no-separator ""
      :--tabstop :2}
     :grep
     {:git_icons false
      :path_shorten true
      :rg_opts rg-opts}
     :keymap
     {:builtin
      {:<c-b> :preview-page-up
       :<c-f> :preview-page-down}
      :fzf
      {:ctrl-b :preview-page-up ; For git preview
       :ctrl-d :half-page-down
       :ctrl-f :preview-page-down ; For git preview
       :ctrl-u :half-page-up}}
     :lsp
     {:fzf_opts {:--with-nth :2..} ; Hide the file path
      :symbols {:fzf_opts {:--with-nth :-3..}}}
     :winopts
     {:hl {:border :WinSeparator}
      :preview
      {:border :noborder ; For git preview
       :scrollbar false
       :title false
       :winopts {:number false}}}})

  (cmd "FzfLua register_ui_select")

  (let
    [with-pijulignore?
      (fn [str]
        ; Both fd and rg rise an error if --ignore-file
        ; doesn't exist so it must be added conditionally
        (if (= (f.filereadable :.pijulignore) 1)
          (string.format "%s %s" str "--ignore-file .pijulignore")
          str))]

    (fn files []
      (fzf.files
        {:fd_opts
         (string.format
           "--color never --follow --hidden %s"
           (if
             ; Without the last . fd only finds directories
             ; in Documents and Projects but not $HOME 🤔
             (at-home?) "--exclude .Trash --max-depth 1 --type d . Documents Projects ."
             (with-pijulignore? "--exclude *.enc --type f")))}))

    (fn grep []
      (if
        (at-home?) (print "Do not live grep from ~")
        (fzf.live_grep {:rg_opts (with-pijulignore? rg-opts)})))

    (let [set-map (fn [lhs rhs] (vim.keymap.set :n lhs rhs))]
      (set-map :<leader>b fzf.buffers)
      (set-map :<leader>c fzf.command_history)
      (set-map :<leader>f files)
      (set-map :<leader>g grep)
      (set-map :<leader>h fzf.help_tags)
      (set-map :<leader>o fzf.oldfiles)
      (set-map :<leader>q fzf.quickfix)
      (set-map :z= fzf.spell_suggest))))
