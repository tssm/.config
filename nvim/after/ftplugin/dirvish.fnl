(fn set-map [lhs rhs]
  (vim.keymap.set :n lhs rhs {:buffer 0}))

(set-map :<cr> "")
(set-map :gf "<cmd>call dirvish#open('edit', 0)<cr>")
(set-map :+ "<cmd>lua require'procedures'['create-file'](vim.call('bufname'))<cr>")
