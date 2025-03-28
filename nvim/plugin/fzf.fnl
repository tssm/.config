(let
  [cmd vim.cmd
   commit-format "git log --color --no-merges --pretty=format:'%C(yellow)%h%Creset %s'"
   f vim.fn
   fzf (require :fzf-lua)
   fzf-actions (require :fzf-lua.actions)
   fzf-path (require :fzf-lua.path)
   git-pager "diffr --colors refine-added:foreground:black --colors refine-removed:foreground:black"
   git-diff (string.format "git diff HEAD -- {file} | tail --lines +5 | %s" git-pager)
   rg-opts "--color always --column --glob !.git --glob !.pijul --hidden --no-heading --no-require-git --smart-case --trim"
   {: delete-buffer-and-file} (require :reflex)

   at-home? (fn [] (= (f.getcwd) (fzf-path.HOME)))
   cd?
     (fn [directory]
       (when (at-home?) (cmd (string.format "cd %s" directory))))
   path-from-selection (fn [selected] (. (fzf-path.entry_to_file (. selected 1)) :path))
   parent (fn [path] (f.fnamemodify path ":h"))

   create-file
     (fn [path-suggestion] (f.feedkeys (.. ":edit " path-suggestion)))

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
    {1 :ivy
     :actions
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
     :diagnostics {:severity_limit :warning}
     :defaults
     {:copen false
      :file_icons :mini
      :formatter :path.filename_first
      :git_icons false
      :header false
      :lopen false}
     :files {:fzf_opts {:--info :inline}}
     :fzf_colors {1 true :bg+ "-1"}
     :fzf_opts
     {:--ansi ""
      :--border :none
      :--cycle ""
      :--ellipsis :…
      :--info :inline
      :--height :100%
      :--layout :reverse
      :--no-scrollbar ""
      :--no-separator ""
      :--tabstop :2}
     :git
     {:bcommits
      {:actions {:default fzf-actions.git_checkout}
       :cmd (.. commit-format " <file>")
       :preview (string.format  "git show --color {1} -- {file} | %s" git-pager)}
      :commits
      {:cmd commit-format
       :preview (string.format  "git show --color {1} | %s" git-pager)}
      :stash
      {:actions {:enter fzf-actions.git_stash_pop}
       :preview (string.format "git --no-pager stash show --patch {1} | %s" git-pager)}
      :status {:actions {:shift-tab [fzf-actions.git_stage_unstage fzf-actions.resume]}}}
     :grep
     {:path_shorten true
      :rg_glob true
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
     :lsp {:trim_entry true}
     :previewers
     {:git_diff
      {:cmd_added git-diff
       :cmd_deleted git-diff
       :cmd_modified git-diff
       :cmd_untracked "git diff --no-index /dev/null {file} | tail --lines +7"}}
     :winopts
     {:backdrop 100
      :border :none
      :preview
      {:border :noborder ; For git preview
       :scrollbar false
       :title false
       :winopts {:number false}}}})

  (fzf.register_ui_select)

  (let
    [create-command vim.api.nvim_create_user_command
     opts {:winopts {:fullscreen true}}]
    (create-command :Branches (fn [] (fzf.git_branches opts)) {})
    (create-command
      :Commits
      (fn [args] (if args.bang (fzf.git_bcommits opts) (fzf.git_commits opts)))
      {:bang true})
    (create-command :Stashed (fn [] (fzf.git_stash opts)) {})
    (create-command :Status (fn [] (fzf.git_status opts)) {}))

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
           "--color never --follow --hidden --no-require-git %s"
           (if
             ; Without the last . fd only finds directories
             ; in Documents and Projects but not $HOME 🤔
             (at-home?) "--exclude .Trash --max-depth 1 . Documents Projects ."
             (with-pijulignore? "--exclude *.enc --type f")))}))

    (fn grep []
      (if
        (at-home?) (fzf.grep)
        (fzf.live_grep {:rg_opts (with-pijulignore? rg-opts)})))

    (let [set-map (fn [lhs rhs] (vim.keymap.set :n lhs rhs))]
      (set-map :<leader>b fzf.buffers)
      (set-map :<leader>c fzf.command_history)
      (set-map :<leader>f files)
      (set-map :<leader>g grep)
      (set-map :<leader>h fzf.help_tags)
      (set-map :<leader>o fzf.oldfiles)
      (set-map :<leader>q fzf.quickfix)
      (set-map :<leader>/ fzf.lgrep_curbuf)
      (set-map :<leader>* fzf.grep_cword)
      (set-map :z= fzf.spell_suggest))))
