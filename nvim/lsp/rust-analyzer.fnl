(let [root (require :root)]
  {:cmd [:rust-analyzer]
   :filetypes [:rust]
   :root_markers (root [:Cargo.toml])})
