(let [{: root} (require :procedures)]
 (vim.lsp.start {
   :cmd [:ccls]
   :filetypes [:c :cpp]
   :root_dir (root [:.ccls :compile_commands.json] (vim.api.nvim_buf_get_name 0))
   :single_file_support false}))
