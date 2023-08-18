(let [g vim.g]
  (when g.neovide
    (vim.cmd.cd :$HOME)
    (set g.neovide_fullscreen true)
    (set g.neovide_theme :auto)
    (let
      [all-modes [:c :i :l :n :o :t :v]
       scale-by
         (fn [delta] (set g.neovide_scale_factor (* g.neovide_scale_factor delta)))
       set-map (fn [mode lhs rhs] (vim.keymap.set mode lhs rhs {:remap true}))]
      (set-map all-modes :<d-b> :<cmd>make<cr>)

      (set-map :c :<d-v> :<c-r>+)
      (set-map :i :<d-v> :<esc>pa)
      (set-map :t :<d-v> :<esc>pa)

      (set-map all-modes :<d--> (fn [] (scale-by (/ 1 1.25))))
      (set-map all-modes :<d-0> (fn [] (set g.neovide_scale_factor 1.0)))
      (set-map all-modes :<d-=> (fn [] (scale-by 1.25)))

      (set-map all-modes :<d-n> "<cmd>silent !open -na neovide<cr>")
      (set-map all-modes :<d-s> "<cmd>silent wall<cr>")
      (set-map all-modes :<d-t> :<cmd>tabnew<cr>)
      (set-map all-modes :<d-w> :<cmd>tabclose<cr>)
      (set-map all-modes :<D-W> :<cmd>qall<cr>))))
