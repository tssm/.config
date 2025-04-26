(let
  [capabilities (vim.lsp.protocol.make_client_capabilities)
   root (require :root)]
  (set capabilities.textDocument.formatting.dynamicRegistration false)
  {:capabilities capabilities
   :cmd [:fennel-ls]
   :filetypes [:fennel]
   :root_markers (root [:fnl :lua])
   :settings
   {:fennel-ls
    {:extra-globals :vim
     :lua-version :lua5.1}}
   :single_file_support true})
