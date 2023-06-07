(vim.loader.enable)

(let [g vim.g]
  ; Disable unused plug-ins
  (set g.loaded_2html_plugin true)
  (set g.loaded_getscriptPlugin true)
  (set g.loaded_gzip true)
  (set g.loaded_logipat true)
  (set g.loaded_matchparen true)
  (set g.loaded_matchit true)
  (set g.loaded_netrw true)
  (set g.loaded_netrwPlugin true)
  (set g.loaded_rrhelper true)
  (set g.loaded_spellfile_plugin true)
  (set g.loaded_tarPlugin true)
  (set g.loaded_vimballPlugin true)
  (set g.loaded_zipPlugin true)
  ; Disable unused providers
  (set g.loaded_node_provider false)
  (set g.loaded_perl_provider false)
  (set g.loaded_python_provider false)
  (set g.loaded_python3_provider false)
  (set g.loaded_ruby_provider false)

  ; Leaders
  (let
    [set-map (fn [lhs rhs] (vim.keymap.set "" lhs rhs))]
    ; Disable unused built-in mappings so they are available for whatever
    (set-map :s "")

    ; Leaders
    (set-map :<cr> "")
    (set g.mapleader "\r")
    (set-map :<space> "")
    (set g.maplocalleader " ")))
