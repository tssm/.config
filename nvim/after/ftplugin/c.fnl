(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:ccls]
     :filetypes [:c :cpp]
     :root_dir (root [:.ccls :compile_commands.json])
     :single_file_support false}))
