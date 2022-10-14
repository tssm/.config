; By default omnifunc is set for SQL files so we need to clear it to get LSP
; working automatically
(set vim.bo.omnifunc "")

(vim.lsp.start
  {:cmd [:sqls]
   :filetypes [:sql]
   :single_file_support true})
