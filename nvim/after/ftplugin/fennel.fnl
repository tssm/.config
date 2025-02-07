(vim.opt.iskeyword:append [:_])

(let
  [capabilities (vim.lsp.protocol.make_client_capabilities)
   root (require :root)]
  ; Formatting is provided by Parinfer
  (set capabilities.textDocument.formatting.dynamicRegistration false)
  (vim.lsp.start
    {:capabilities capabilities
     :cmd [:fennel-ls]
     :filetypes [:fennel]
     :root_dir (root [:fnl :lua])
     :settings
     {:fennel-ls
      {:extra-globals :vim
       :lua-version :lua5.1}}
     :single_file_support true}))
