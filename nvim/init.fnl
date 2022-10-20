; Disable unused features
(local g vim.g)
(set g.loaded_netrw true)
(set g.loaded_netrwPlugin true)
(set g.loaded_node_provider false)
(set g.loaded_perl_provider false)
(set g.loaded_python_provider false)
(set g.loaded_python3_provider false)
(set g.loaded_ruby_provider false)

; Leaders
(fn set-map [lhs rhs]
  (vim.keymap.set :n lhs rhs))
(set-map :<cr> "")
(set g.mapleader "\r")
(set-map :<space> "")
(set g.maplocalleader " ")
