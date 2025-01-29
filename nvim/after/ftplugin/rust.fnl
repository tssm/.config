(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:rust-analyzer]
     :filetypes [:rust]
     :root_dir (root [:Cargo.toml])}))
