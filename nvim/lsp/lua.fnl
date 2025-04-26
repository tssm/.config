(let [root (require :root)]
  {:cmd [:lua-language-server]
   :filetypes [:lua]
   :root_markers (root [:.luarc.json])})
