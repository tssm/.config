(set vim.opt.scrollback 100000)

(vim.api.nvim_create_user_command
  :T
  "vsplit | terminal <args>"
  {:complete :shellcmd
   :nargs :*})

(vim.api.nvim_set_keymap :t :<esc> :<c-\><c-n> {:noremap true})
