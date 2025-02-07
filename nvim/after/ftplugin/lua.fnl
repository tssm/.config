(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:lua-language-server]
     :filetypes [:lua]
     :root_dir (root [:.luarc.json])}))
