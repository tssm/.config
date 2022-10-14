(let [{: root} (require :procedures)]
  (vim.lsp.start
    {:cmd [:purescript-language-server :--stdio]
     :filetypes [:purescript]
     :root_dir (root [:spago.dhall] (vim.api.nvim_buf_get_name 0))}))
