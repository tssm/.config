(let [root (require :root)]
  {:cmd [:haskell-language-server-wrapper :--lsp]
   :filetypes [:haskell :lhaskell]
   :root_markers (root [:cabal.project])})
