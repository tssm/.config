(vim.diagnostic.config
  {:float {:header false}
   :severity_sort true
   :signs false
   :update_in_insert true
   :underline {:severity {:min vim.diagnostic.severity.WARN}}
   :virtual_text {:spacing 0}})
