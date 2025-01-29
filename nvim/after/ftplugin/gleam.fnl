(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:gleam :lsp]
     :filetypes [:gleam]
     :root_dir (root [:gleam.toml])}))
