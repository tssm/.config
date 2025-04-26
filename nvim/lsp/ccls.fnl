(let [root (require :root)]
  {:cmd [:ccls]
   :filetypes [:c :cpp]
   :root_markers (root [:.ccls :compile_commands.json])
   :single_file_support false})
