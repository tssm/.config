(let [{: root} (require :procedures)]
  (vim.lsp.start
    {:cmd [:rust-analyzer]
     :filetypes [:rust]
     :root_dir (root [:Cargo.toml] (vim.api.nvim_buf_get_name 0))}))
