(set vim.opt.scrollback 100000)

(vim.api.nvim_create_user_command
  :T
  "vsplit | terminal <args>"
  {:complete :shellcmd
   :nargs :*})

(vim.keymap.set :t :<esc> :<c-\><c-n>)
