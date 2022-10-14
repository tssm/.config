(let [{: root} (require :procedures)]
  (vim.lsp.start
    {:cmd [:haskell-language-server-wrapper :--lsp]
     :filetypes [:haskell :lhaskell]
     :root_dir (root [:cabal.project] (vim.api.nvim_buf_get_name 0))}))
