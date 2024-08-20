(set vim.opt.scrollback 100000)

(vim.api.nvim_create_user_command
  :T
  "vsplit | terminal <args>"
  {:complete :shellcmd
   :nargs :*})

(vim.api.nvim_create_autocmd :TermOpen
  {:callback
   (fn [args]
     ; Show commit under cursor
     (vim.keymap.set :n :gs
       (fn [] (vim.cmd.terminal "git show <cword>"))
       {:buffer args.buf})
     ; Re-run command
     (vim.keymap.set :n :r
       (fn []
         (let
           [currentbuf (vim.api.nvim_get_current_buf)
            command
              (vim.fn.substitute
                (vim.api.nvim_buf_get_name 0)
                "term:\\/\\/\\(.*\\)\\/\\/\\d\\+:\\ze"
                "" "")]
           (vim.cmd (string.format "keepalt terminal %s" command))
           (vim.api.nvim_buf_delete currentbuf {:force true})))
       {:buffer args.buf}))})

(vim.keymap.set :t :<esc> :<c-\><c-n>)
