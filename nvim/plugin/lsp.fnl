(local window-options {:pad_bottom 1 :pad_top 1})
(tset
  vim.lsp.handlers
  :textDocument/hover
  (vim.lsp.with vim.lsp.handlers.hover window-options))
(tset
  vim.lsp.handlers
  :textDocument/signatureHelp
  (vim.lsp.with vim.lsp.handlers.signature_help window-options))

(fn set-map [buffer-number lhs func]
  (vim.keymap.set
    :n
    lhs
    (string.format "<cmd>lua %s<cr>" func)
    {:buffer buffer-number :silent true}))

(set My.go_to_diagnostic_options
  {:float window-options
   :severity {:min vim.diagnostic.severity.WARN}})
(set My.show_diagnostic_options ((. (require :aniseed.core) :merge) window-options {:scope :line}))

(local api vim.api)
(local augroup (api.nvim_create_augroup :lsp {:clear true}))
(local autocmd api.nvim_create_autocmd)
(autocmd
  :LspAttach
  {:callback
   (fn [args]
     (each [_ reference (ipairs [:Read :Text :Write])]
       (api.nvim_command (string.format "highlight! link LspReference%s Search" reference)))

     ; Buffer mappings
     (local buffer-number args.buf)
     (set-map buffer-number :K "vim.lsp.buf.hover()")
     (when (= (vim.fn.mapcheck :<localleader>hi :n) :<Nop>)
       (set-map buffer-number :<localleader>hi "vim.lsp.buf.document_highlight()"))
     (set-map buffer-number :<localleader>a "vim.lsp.buf.code_action()")
     (set-map buffer-number :<localleader>r "vim.lsp.buf.rename()")
     (set-map buffer-number :<localleader>ds "require'telescope.builtin'.lsp_document_symbols({entry_maker = My.entry_for_lsp_symbol})")
     (set-map buffer-number :<localleader>ws "require'telescope.builtin'.lsp_dynamic_workspace_symbols({entry_maker = My.entry_for_lsp_symbol})")
     (set-map buffer-number :<localleader>sd "vim.diagnostic.open_float(0, My.show_diagnostic_options)")
     (set-map buffer-number :<localleader>ss "vim.lsp.buf.signature_help()")
     (set-map buffer-number "[d" "vim.diagnostic.goto_prev(My.go_to_diagnostic_options)")
     (set-map buffer-number "]d" "vim.diagnostic.goto_next(My.go_to_diagnostic_options)")
     (set-map buffer-number :<localleader>u "require'telescope.builtin'.lsp_references({entry_maker = My.entry_for_location()})")

     (autocmd
       :BufWritePre
       {:buffer buffer-number
        :callback vim.lsp.buf.format
        :group augroup})
     (autocmd
       [:CursorMoved :CursorMovedI]
       {:callback (. (require :nvim-lightbulb) :update_lightbulb)
        :group augroup})
     (autocmd
       :InsertEnter
       {:buffer buffer-number
        :callback vim.lsp.buf.clear_references
        :group augroup}))
   :group augroup})
