(let [root (require :root)]
  {:cmd [:purescript-language-server :--stdio]
   :filetypes [:purescript]
   :root_markers (root [:spago.dhall])})
