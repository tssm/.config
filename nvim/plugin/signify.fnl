(let [g vim.g]
  (set g.signify_priority 0)
  (set g.signify_sign_add "")
  (set g.signify_sign_change "")
  (set g.signify_sign_change_delete "")
  (set g.signify_sign_delete "")
  (set g.signify_sign_delete_first_line g.signify_sign_delete)
  (set g.signify_sign_show_count false))

(let [set-map (fn [lhs rhs] (vim.keymap.set :n lhs rhs {:buffer 0}))]
  (vim.api.nvim_create_autocmd
    "User SignifyAutocmd"
    {:callback
      (fn []
        (set-map "]h" "<plug>(signify-next-hunk)")
        (set-map "[h" "<plug>(signify-prev-hunk)")
        (set-map "]H" "9999]h")
        (set-map "[H" "9999[h")
        (set-map :sdf :<cmd>SignifyDiff<cr>)
        (set-map :sdh :<cmd>SignifyHunkDiff<cr>)
        (set-map :su :<cmd>SignifyHunkUndo<cr>))
     :group (vim.api.nvim_create_augroup :signify {:clear true})}))
