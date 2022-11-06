(let [opt vim.opt]
  (set opt.clipboard [:unnamed :unnamedplus])
  (set opt.confirm true)
  (opt.diffopt:append [:algorithm:patience :vertical])
  (set opt.mouse :a)
  (set opt.ruler false)
  (set opt.sessionoptions [:curdir :help :tabpages :winsize])
  (set opt.shada "'100,h,rman:,rocto:,rterm:,r/nix/,r/private/tmp/,r/private/var/")
  (set opt.shortmess :csF)
  (set opt.spelloptions :camel)
  (set opt.tildeop true)
  (set opt.visualbell true)
  (set opt.wildignorecase true)

  ; Tab pages
  (set opt.splitbelow true)
  (set opt.splitright true))

(let
  [augroup
    (vim.api.nvim_create_augroup
      :behaviour
      {:clear true})
   autocmd vim.api.nvim_create_autocmd]
  (autocmd
    :VimEnter
    {:command :clearjumps
     :group augroup})
  (autocmd
    :VimLeave
    {:command "set guicursor=a:ver35-blinkon1"
     :group augroup})
  (autocmd
    :VimResized
    {:command "wincmd ="
     :group augroup}))
