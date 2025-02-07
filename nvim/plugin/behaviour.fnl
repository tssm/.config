(let [opt vim.opt]
  (set opt.clipboard [:unnamed :unnamedplus])
  (set opt.confirm true)
  (opt.diffopt:append [:algorithm:patience :vertical])
  (set opt.exrc true)
  (set opt.mouse :a)
  (set opt.ruler false)
  (set opt.sessionoptions [:curdir :help :tabpages :winsize])
  (set opt.shada "'100,h,rman:,rocto:,rterm:,r/nix/,r/private/tmp/,r/private/var/")
  (set opt.shortmess :csCFSW)
  (set opt.spelloptions :camel)
  (set opt.tildeop true)
  (set opt.visualbell true)
  (set opt.wildignorecase true)

  ; Tab pages
  (set opt.splitbelow true)
  (set opt.splitright true))

(let [autocmd vim.api.nvim_create_autocmd]
  (let [augroup (vim.api.nvim_create_augroup :behaviour {:clear true})]
    (autocmd
      :VimEnter
      {:command :clearjumps
       :group augroup})
    (autocmd
      :VimResized
      {:command "wincmd ="
       :group augroup}))
  (let
     [group (vim.api.nvim_create_augroup :cd {:clear true})
      root (require :root)]
     (autocmd
       :BufEnter
       {:callback
         (fn []
           (when
             (and ; Nnormal or dirvish buffer...
               (or (= (vim.opt.buftype:get) "") (= (vim.opt.filetype:get) :dirvish))
               ; ...while CWD is $HOME
               (= (vim.fn.getcwd) (os.getenv :HOME)))
             (vim.fn.chdir
               (case (root [])
                 root root
                 _ (vim.fn.expand :%:h:p)))
             nil)) ; Throws without this
        :group group})
     (autocmd
       :LspAttach
       {:callback
         (fn [args]
           (case (vim.lsp.get_client_by_id args.data.client_id)
             ; TODO: Only if CWD hasn't been changed yet
             client (vim.fn.chdir client.root_dir)))
        :group group})))
