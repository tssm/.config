(vim.opt.iskeyword:append [:_])

(let
  [capabilities (vim.lsp.protocol.make_client_capabilities)
   root (require :root)]
  (set capabilities.textDocument.formatting.dynamicRegistration false)
  (set capabilities.offsetEncoding [:utf-8 :utf-16])
  (vim.lsp.start
    {:capabilities capabilities
     :cmd [:fennel-ls]
     :filetypes [:fennel]
     :root_dir (root [:flsproject.fnl])}))
