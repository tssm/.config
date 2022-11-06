(let
  [{: create-file} (require :procedures)
   set-map (fn [lhs rhs] (vim.keymap.set :n lhs rhs {:buffer 0}))]
  (set-map :<cr> "")
  (set-map :gf "<cmd>call dirvish#open('edit', 0)<cr>")
  (set-map :+ (fn [] (create-file (vim.fn.bufname)))))
