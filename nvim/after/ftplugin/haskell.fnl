(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:haskell-language-server-wrapper :--lsp]
     :filetypes [:haskell :lhaskell]
     :root_dir (root [:cabal.project])}))
