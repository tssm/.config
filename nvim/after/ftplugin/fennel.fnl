(vim.api.nvim_create_user_command
  :AniseedCompileAll
  (fn []
    (let
       [call vim.fn
        compile (require :aniseed.compile)
        files (call.glob "**/*.fnl" false true)]
       (each [_ fennel-path (ipairs files)]
         (let [lua-path (.. (call.fnamemodify fennel-path ":r") ".lua")]
           (compile.file fennel-path lua-path)))))
  {})
