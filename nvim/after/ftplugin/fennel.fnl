(let [{: root} (require :procedures)]
  (vim.lsp.start
    {:cmd [:fennel-language-server]
     :filetypes [:fennel]
     :root_dir (root [:fnl :lua] (vim.api.nvim_buf_get_name 0))
     :settings
     {:fennel
      {:diagnostics {:globals [:vim]}
       :workspace
       {:library (vim.api.nvim_list_runtime_paths)}}}
     :single_file_support true}))
