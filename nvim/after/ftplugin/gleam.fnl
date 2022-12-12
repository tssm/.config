(let [{: root} (require :procedures)]
  (vim.lsp.start
    {:cmd [:gleam :lsp]
     :filetypes [:gleam]
     :root_dir (root [:gleam.toml] (vim.api.nvim_buf_get_name 0))}))
