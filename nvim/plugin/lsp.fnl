(vim.fn.sign_define [{:name :LightBulbSign :text "" :texthl :DiagnosticSignWarn}])

(let
  [api vim.api
   lsp vim.lsp
   lsp-handlers lsp.handlers
   window-options {:pad_bottom 1 :pad_top 1}]
  (each [_ reference (ipairs [:Read :Text :Write])]
    (api.nvim_command (string.format "highlight! link LspReference%s Search" reference)))

  (tset
    lsp-handlers
    :textDocument/hover
    (lsp.with lsp-handlers.hover window-options))
  (tset
    lsp-handlers
    :textDocument/signatureHelp
    (lsp.with lsp-handlers.signature_help window-options))

  (let
    [augroup (api.nvim_create_augroup :lsp {:clear true})
     autocmd api.nvim_create_autocmd]

    (autocmd
      :LspAttach
      {:callback
       (fn [args]
         (let
           [buffer-number args.buf
            lsp-buf lsp.buf]

           (let [client (lsp.get_client_by_id args.data.client_id)]
             (if
               client.server_capabilities.documentRangeFormattingProvider
                 ((. (require :lsp-format-modifications) :attach) client buffer-number {:format_on_save true})
               client.server_capabilities.documentFormattingProvider
                 (autocmd
                   :BufWritePre
                   {:buffer buffer-number
                    :callback lsp-buf.format
                    :group augroup})))

           (let
             [diagnostic vim.diagnostic
              go-to-diagnostic-options
                {:float window-options
                 :severity {:min diagnostic.severity.WARN}}
              set-map
                (fn [buffer-number lhs rhs]
                  (vim.keymap.set
                    :n lhs rhs
                    {:buffer buffer-number :silent true}))
              {: merge} (require :aniseed.core)
              show-diagnostic-options (merge window-options {:scope :line})
              telescope (require :telescope.builtin)
              telescope-entries (require :telescope-entries)]
             (set-map buffer-number :K lsp-buf.hover)
             (when (= (vim.fn.mapcheck :<localleader>hi :n) :<Nop>)
               (set-map buffer-number :<localleader>hi lsp-buf.document_highlight))
             (set-map buffer-number :<localleader>a lsp-buf.code_action)
             (set-map buffer-number :<localleader>r lsp-buf.rename)
             (set-map buffer-number :<localleader>ds (fn [] (telescope.lsp_document_symbols {:entry_maker telescope-entries.for-lsp-symbol})))
             (set-map buffer-number :<localleader>ws (fn [] (telescope.lsp_dynamic_workspace_symbols {:entry_maker telescope-entries.for-lsp-symbol})))
             (set-map buffer-number :<localleader>sd (fn [] (diagnostic.open_float 0 show-diagnostic-options)))
             (set-map buffer-number :<localleader>ss lsp-buf.signature_help)
             (set-map buffer-number "[d" (fn [] (diagnostic.goto_prev go-to-diagnostic-options)))
             (set-map buffer-number "]d" (fn [] (diagnostic.goto_next go-to-diagnostic-options)))
             (set-map buffer-number :<localleader>u (fn [] (telescope.lsp_references {:entry_maker (telescope-entries.for-location)}))))

           (autocmd
             [:CursorMoved :CursorMovedI]
             {:callback (. (require :nvim-lightbulb) :update_lightbulb)
              :group augroup})
           (autocmd
             :InsertEnter
             {:buffer buffer-number
              :callback lsp-buf.clear_references
              :group augroup})))
       :group augroup})))
