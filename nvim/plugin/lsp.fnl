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
              set-map (fn [b lhs rhs] (vim.keymap.set :n lhs rhs {:buffer b :silent true}))]
             (set-map true :g0 fzf-lua.lsp_document_symbols)
             (set-map true :g1 fzf-lua.lsp_live_workspace_symbols)
             (set-map true :gra fzf-lua.lsp_code_actions)
             (set-map true :grd fzf-lua.lsp_workspace_diagnostics)
             (when (= (vim.fn.mapcheck :grh :n) :<Nop>)
               (set-map true :grh lsp-buf.document_highlight))
             (set-map true :grr
               (fn [] (fzf-lua.lsp_references {:ignore_current_line true :jump1 true}))))

           (autocmd
             :InsertEnter
             {:buffer buffer-number
              :callback lsp-buf.clear_references
              :group augroup})))
       :group augroup})))
