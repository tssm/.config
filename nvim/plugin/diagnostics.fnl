(vim.diagnostic.config
  {:float {:header false}
   :severity_sort true
   :update_in_insert true
   :underline {:severity {:min vim.diagnostic.severity.WARN}}
   :virtual_text
   {:severity {:min vim.diagnostic.severity.WARN}
    :spacing 0}})

(vim.fn.sign_define
  [{:name :DiagnosticSignError :text "" :texthl :DiagnosticSignError}
   {:name :DiagnosticSignHint :text "" :texthl :DiagnosticSignHint}
   {:name :DiagnosticSignInfo :text "" :texthl :DiagnosticSignInfo}
   {:name :DiagnosticSignWarn :text "" :texthl :DiagnosticSignWarn}])
