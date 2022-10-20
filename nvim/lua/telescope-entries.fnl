(local entry-display (require :telescope.pickers.entry_display))

(fn path [entry] (or entry.filename (vim.api.nvim_buf_get_name entry.bufnr)))

(fn for-location []
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

(fn for-lsp-symbol [entry]
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

(fn for-tree-sitter-symbol [entry]
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

{:for-location for-location
 :for-lsp-symbol for-lsp-symbol
 :for-tree-sitter-symbol for-tree-sitter-symbol}
