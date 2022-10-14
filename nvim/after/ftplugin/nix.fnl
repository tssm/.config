(let [{: repo} (require :procedures)]
  (vim.lsp.start
    {:cmd [:rnix-lsp]
     :filetypes [:nix]
     :root_dir (repo (vim.api.nvim_buf_get_name 0))}))
