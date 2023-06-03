(let
  [set-map
    (fn [lhs cmd bufnr]
      (vim.keymap.set
        :n lhs
        (string.format "<cmd>Gitsigns %s<cr>" cmd)
        {:buffer bufnr}))
   {: setup} (require :gitsigns)]
  (setup
    {:attach_to_untracked false
     :on_attach
      (fn [bufnr]
        (each
          [lhs rhs
            (pairs
              {:gs :blame_line
               :gr :reset_hunk
               :gd :preview_hunk_inline
               "]h" :next_hunk
               "[h" :prev_hunk})]
          (set-map lhs rhs bufnr)))
     :preview_config {:border :solid}}))
