(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:purescript-language-server :--stdio]
     :filetypes [:purescript]
     :root_dir (root [:spago.dhall])}))
