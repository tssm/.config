(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:lua-language-server]
     :filetypes [:lua]
     :root_dir (root [:lua])
     :settings
     {:Lua
      {:diagnostics {:globals [:vim]}
       :runtime
       {:path (vim.split package.path ";")
        :version :LuaJIT}
       :workspace
       {:library
        {"vim.fn.expand('$VIMRUNTIME/lua')" true
         "vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')" true}}}}}))
