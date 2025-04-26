(let [root (require :root)]
  {:cmd [:gleam :lsp]
   :filetypes [:gleam]
   :root_markers (root [:gleam.toml])})
