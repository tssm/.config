; Disable unused features
(local g vim.g)
(set g.loaded_netrw true)
(set g.loaded_netrwPlugin true)
(set g.loaded_node_provider false)
(set g.loaded_perl_provider false)
(set g.loaded_python_provider false)
(set g.loaded_python3_provider false)
(set g.loaded_ruby_provider false)

; Enable opt-in features
(set g.do_filetype_lua 1)

; Leaders
(fn set-map [lhs rhs]
	(vim.api.nvim_set_keymap :n lhs rhs {:noremap true}))
(set-map :<cr> "")
(set g.mapleader "\r")
(set-map :<space> "")
(set g.maplocalleader " ")

; Load scripts
(global My {})
(require :behaviour)
(require :command-line)
(require :lsp)
(require :mappings)
(require :search-and-replace)
(require :status-line)
(require :terminal)
(require :text)
(require :ui)
