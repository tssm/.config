(let [{: setup} (require :mini.jump2d)]
  (setup
    {:allowed_lines {:blank false :fold false}
     :allowed_windows {:not_current false}
     :mappings {:start_jumping ""}
     :silent true}))

(let
  [{:builtin_opts opts : start} (require :mini.jump2d)
   merge (fn [a b] (vim.tbl_deep_extend :force a b))
   set-map (fn [lhs opts] (vim.keymap.set [:n :o :x] lhs (fn [] (start opts))))]
  (set-map :f opts.single_character)
  (set-map :F opts.single_character)
  (set-map :gj
    (merge
      opts.line_start
      {:allowed_lines
       {:blank true
        :cursor_at false
        :cursor_before false
        :fold true}}))
  (set-map :gk
    (merge
      opts.line_start
      {:allowed_lines
       {:blank true
        :cursor_at false
        :cursor_after false
        :fold true}})))
