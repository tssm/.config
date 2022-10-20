(local window-options {:pad_bottom 1 :pad_top 1})
(tset
  vim.lsp.handlers
  :textDocument/hover
  (vim.lsp.with vim.lsp.handlers.hover window-options))
(tset
  vim.lsp.handlers
  :textDocument/signatureHelp
  (vim.lsp.with vim.lsp.handlers.signature_help window-options))

(fn set-map [buffer-number lhs rhs]
  (vim.keymap.set
    :n
    lhs
    rhs
    {:buffer buffer-number :silent true}))

(local
  go-to-diagnostic-options
  {:float window-options
   :severity {:min vim.diagnostic.severity.WARN}})
(local show-diagnostic-options ((. (require :aniseed.core) :merge) window-options {:scope :line}))

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
     (local telescope (require :telescope.builtin))
     (local telescope-entries (require :telescope-entries))
     (set-map buffer-number :K vim.lsp.buf.hover)
     (when (= (vim.fn.mapcheck :<localleader>hi :n) :<Nop>)
       (set-map buffer-number :<localleader>hi vim.lsp.buf.document_highlight))
     (set-map buffer-number :<localleader>a vim.lsp.buf.code_action)
     (set-map buffer-number :<localleader>r vim.lsp.buf.rename)
     (set-map buffer-number :<localleader>ds (fn [] (telescope.lsp_document_symbols {:entry_maker telescope-entries.for-lsp-symbol})))
     (set-map buffer-number :<localleader>ws (fn [] (telescope.lsp_dynamic_workspace_symbols {:entry_maker telescope-entries.for-lsp-symbol})))
     (set-map buffer-number :<localleader>sd (fn [] (vim.diagnostic.open_float 0 show-diagnostic-options)))
     (set-map buffer-number :<localleader>ss vim.lsp.buf.signature_help)
     (set-map buffer-number "[d" (fn [] (vim.diagnostic.goto_prev go-to-diagnostic-options)))
     (set-map buffer-number "]d" (fn [] (vim.diagnostic.goto_next go-to-diagnostic-options)))
     (set-map buffer-number :<localleader>u (fn [] (telescope.lsp_references {:entry_maker (telescope-entries.for-location)})))

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
