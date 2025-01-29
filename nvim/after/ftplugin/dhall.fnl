(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:dhall-lsp-server]
     :filetypes [:dhall]
     :root_dir (root [])}))
