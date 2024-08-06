(let [api vim.api]
  (each [_ reference (ipairs [:Read :Text :Write])]
    (api.nvim_command (string.format "highlight! link LspReference%s Search" reference)))

  (let
    [augroup (api.nvim_create_augroup :lsp {:clear true})
     autocmd api.nvim_create_autocmd]

    (autocmd
      :LspAttach
      {:callback
       (fn [args]
         (let [{: setup} (require :nvim-lightbulb)]
           (setup
             {:autocmd {:enabled true}
              :sign {:enabled false}
              :virtual_text {:enabled true}}))
         (let
           [buffer-number args.buf
            lsp-buf vim.lsp.buf]

           (let [client (vim.lsp.get_client_by_id args.data.client_id)]
             (when client.server_capabilities.documentFormattingProvider
               (autocmd
                 :BufWritePre
                 {:buffer buffer-number
                  :callback (fn [] (lsp-buf.format {:bufnr buffer-number}))
                  :group augroup})))

           (let
             [fzf-lua (require :fzf-lua)
              set-map
                (fn [buffer-number lhs rhs]
                  (vim.keymap.set
                    :n lhs rhs
                    {:buffer buffer-number :silent true}))]
             (set-map buffer-number :K lsp-buf.hover)
             (when (= (vim.fn.mapcheck :<localleader>hi :n) :<Nop>)
               (set-map buffer-number :<localleader>hi lsp-buf.document_highlight))
             (set-map buffer-number :<localleader>a fzf-lua.lsp_code_actions)
             (set-map buffer-number :<localleader>r lsp-buf.rename)
             (set-map buffer-number :<localleader>ds fzf-lua.lsp_document_symbols)
             (set-map buffer-number :<localleader>wd fzf-lua.lsp_workspace_diagnostics)
             (set-map buffer-number :<localleader>ws fzf-lua.lsp_live_workspace_symbols)
             (set-map buffer-number :<localleader>u
               (fn [] (fzf-lua.lsp_references {:ignore_current_line true :jump_to_single_result true}))))

           (autocmd
             :InsertEnter
             {:buffer buffer-number
              :callback lsp-buf.clear_references
              :group augroup})))
       :group augroup})))
