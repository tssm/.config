(vim.opt.iskeyword:append [:_])

(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:fennel-language-server]
     :filetypes [:fennel]
     :root_dir (root [:fnl :lua])
     :settings
     {:fennel
      {:diagnostics {:globals [:vim]}
       :workspace
       {:library (vim.api.nvim_list_runtime_paths)}}}
     :single_file_support true}))
