(let
  [gitsigns (require :gitsigns)
   set-map
     (fn [lhs func bufnr]
       (vim.keymap.set :n lhs
         (. gitsigns func)
         {:buffer bufnr}))]
  (gitsigns.setup
    {:attach_to_untracked false
     :on_attach
     (fn [bufnr]
       (each
         [lhs rhs
           (pairs
             {:gb :blame_line
              :gr :reset_hunk
              :gs :stage_hunk
              :gp :preview_hunk_inline
              :gu :undo_stage_hunk
              "]h" :next_hunk
              "[h" :prev_hunk})]
         (set-map lhs rhs bufnr)))
     :preview_config {:border :solid}
     :signs
     {:add {:text :│}
      :change {:text :│}
      :changedelete {:text :│}}
     :signs_staged {:changedelete {:text :┃}}}))
