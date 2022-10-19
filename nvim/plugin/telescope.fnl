(local aniseed (require :aniseed.core))
(local pickers (require :telescope.builtin))
(local actions (require :telescope.actions))
(local actions-state (require :telescope.actions.state))
(local procedures (require :procedures))
(local reflex (require :reflex))
(local telescope (require :telescope))

; Custom actions

(fn change-directory? [directory]
  (when
    (and
      (= (vim.fn.isdirectory directory) 1)
      (= (vim.fn.getcwd) (os.getenv :HOME)))
    (vim.cmd (.. "cd " directory))))

(fn create-file []
  (procedures.create-file (aniseed.first (actions-state.get_selected_entry))))

(fn delete-file [current-picker]
  (current-picker:delete_selection
    (fn [selection] (reflex.delete-buffer-and-file (aniseed.first selection)))))

(fn delete [prompt-buffer-number]
  (local current-picker (actions-state.get_current_picker prompt-buffer-number))
  (local prompt-title (. current-picker :prompt_title))
  (match prompt-title
    "Buffers" (actions.delete_buffer prompt-buffer-number)
    "Find Files" (delete-file current-picker)
    "Oldfiles" (delete-file current-picker)))

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
  (vim.cmd
    (..
      "edit "
      (vim.fn.fnamemodify
        (aniseed.first (actions-state.get_selected_entry))
        ":h"))))

(fn open-file [prompt-buffer-number]
  (actions.select_default prompt-buffer-number)
  (change-directory? (aniseed.first (actions-state.get_selected_entry))))

(fn open-terminal [prompt-buffer-number]
  (local selected-entry (aniseed.first (actions-state.get_selected_entry)))
  (local directory
    (if
      (= (vim.fn.isdirectory selected-entry) 1) selected-entry
      (vim.fn.fnamemodify selected-entry ":h")))
  (actions.close prompt-buffer-number)
  ; termopen destroys the current buffer and cannot be called from a modified
  ; one so before calling it a new empty and unchanged buffer is created
  (vim.cmd :enew)
  (vim.fn.termopen (os.getenv :SHELL) {:cwd directory})
  (change-directory? directory))

(telescope.setup
  {:defaults
   {:dynamic_preview_title true
    :layout_config {:prompt_position :top}
    :mappings
    {:i
     {:<cr> open-file
      :<c-e> edit-first
      :<c-j> actions.move_selection_next
      :<c-k> actions.move_selection_previous
      :<c-n> actions.cycle_history_next
      :<c-p> actions.cycle_history_prev
      :<c-q> actions.smart_send_to_qflist
      :<c-s> actions.select_horizontal
      :<c-x> delete
      :<c-z> open-terminal
      :<c-_> open-directory}}
    :path_display {:truncate true}
    :sorting_strategy :ascending
    :winblend 10}
   :extensions
   {:ui-select [((. (require :telescope.themes) :get_dropdown) {})]}})

; Custom entries

(local entry-display (require :telescope.pickers.entry_display))

(fn path [entry] (or entry.filename (vim.api.nvim_buf_get_name entry.bufnr)))

(fn entry-for-location []
  (local devicon (. (require :telescope.utils) :get_devicons))
  (local strdisplaywidth (. (require :plenary.strings) :strdisplaywidth))

  (fn line-number [entry]
    (or
      entry.lnum
      ; From Telescope itself: "account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker"
      (or
        (and
          (not= entry.info.lnum 0)
          (math.max (math.min entry.info.lnum (vim.api.nvim_buf_line_count entry.bufnr)) 1))
        1)))

  (fn relative-path [path] (string.gsub path (string.format :%s/ (vim.loop.cwd)) ""))

  (local (icon _) (devicon :fname false))
  (local displayer
    (entry-display.create
      {:separator " "
       :items
       [{:width (strdisplaywidth icon)}
        {:remaining true}]}))
  (fn make-display [entry]
    (local (icon hl-group) (devicon entry.filename false))
    (local name (relative-path (path entry)))
    (displayer
      [[icon hl-group]
       (string.format "%s:%d:%d" (if (not= name "") name "🆕") (line-number entry) (or entry.col 1))]))
  (fn [entry]
    (local name (path entry))
    {:value entry
     :ordinal (string.format "%s:%d:%d" (relative-path name) (line-number entry) (or entry.col 1))
     :display make-display
     :bufnr entry.bufnr
     :filename name
     :lnum (line-number entry)
     :col entry.col
     :start entry.start
     :finish entry.finish}))

(fn make-symbol-display []
  (local displayer (entry-display.create {:items [{:remaining true}]}))
  (fn [entry]
    (displayer [(string.format "%s (%s)" entry.symbol_name (entry.symbol_type:lower))])))

(fn entry-for-lsp-symbol [entry]
  (local (symbol-type symbol-name) (entry.text:match "%[(.+)%]%s+(.*)"))
  {:value entry
   :ordinal (.. symbol-name " " symbol-type)
   :display (make-symbol-display)
   :filename (path entry)
   :lnum entry.lnum
   :col entry.col
   :symbol_name symbol-name
   :symbol_type symbol-type
   :start entry.start
   :finish entry.finish})
; This will be used by nvim/lua/lsp.fnl
(set My.entry_for_lsp_symbol entry-for-lsp-symbol)

(fn entry-for-tree-sitter-symbol [entry]
  (local bufnr (vim.api.nvim_get_current_buf))
  (local node (vim.treesitter.get_node_text entry.node bufnr))
  (local ts-utils (require :nvim-treesitter.ts_utils))
  (local (start-row start-col end-row _) (ts-utils.get_node_range entry.node))
  {:value entry
   :kind entry.kind
   :ordinal (.. node " " entry.kind)
   :display (make-symbol-display)
   :filename (vim.api.nvim_buf_get_name bufnr)
   :lnum (+ start-row 1)
   :col start-col
   :symbol_name node
   :symbol_type entry.kind
   :start start_row
   :finish end-row})
; This will be used by nvim/lua/tree-sitter.fnl
(set My.entry_for_tree_sitter_symbol entry-for-tree-sitter-symbol)

; Custom finders

(fn add-pijulignore? [tbl]
  ; Both fd and rg rise an error if --file-ignore doesn't exist so it must be
  ; added conditionally
  (when (= (vim.fn.filereadable :.pijulignore) true)
    (table.insert tbl :--file-ignore=.pijulignore))
  tbl)

(fn find-files []
  (if (= (vim.fn.getcwd) (os.getenv :HOME))
    (pickers.find_files
      {:find_command [:fd :--color=never :--follow :--max-depth=1 :--type=d]
       :search_dirs [:. :Projects]})
    (pickers.find_files
      {:find_command
        (add-pijulignore?
          [:fd :--color=never :--exclude=*.enc :--hidden :--type=f])
       :search_dirs [:.]})))

(fn grep []
  (if (= (vim.fn.getcwd) (os.getenv :HOME))
    (print "Do not live grep from ~")
    (let [grep-command [:rg :--vimgrep]]
      (add-pijulignore? grep-command)
      (pickers.live_grep {:vimgrep_arguments grep-command}))))

; Extensions

(telescope.load_extension :ui-select)

; Mappings

(fn set-map [lhs rhs]
  (vim.keymap.set
    :n
    lhs
    (string.format "<cmd>lua %s<cr>" rhs)
    {:silent true}))

(set-map :<leader>b "require'telescope.builtin'.buffers({entry_maker = My.entry_for_location(), ignore_current_buffer = true, show_all_buffers = false})")

(set-map :<leader>c "require'telescope.builtin'.command_history()")

(set My.find_files find-files)
(set-map :<leader>f "My.find_files()")

(set My.grep grep)
(set-map :<leader>g "My.grep()")

(set-map :<leader>h "require'telescope.builtin'.help_tags()")

(set-map :<leader>o "require'telescope.builtin'.oldfiles()")

(set My.entry_for_location entry-for-location)
(set-map :<leader>q "require'telescope.builtin'.quickfix({entry_maker = My.entry_for_location()})")

(set-map :z= "require'telescope.builtin'.spell_suggest(require'telescope.themes'.get_dropdown())")
