(let [{: repo} (require :procedures)]
  (vim.lsp.start
    {:cmd [:dhall-lsp-server]
     :filetypes [:dhall]
     :root_dir (repo (vim.api.nvim_buf_get_name 0))}))
