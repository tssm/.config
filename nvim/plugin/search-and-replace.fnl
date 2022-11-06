(let [opt vim.opt]
  (set opt.gdefault true) ; Substitutes all matches on a line by default
  (set opt.ignorecase true)
  (set opt.inccommand :nosplit)
  (set opt.smartcase true))

(let [set-map (fn [mode lhs rhs] (vim.keymap.set mode lhs rhs))]
  (set-map :n :n :nzz)
  (set-map :n :N :Nzz)
  (set-map :v :n :nzz)
  (set-map :v :N :Nzz)
  (set-map :n :<leader>s ":%s/\\<<C-r><C-w>\\>/"))

(let
  [augroup
    (vim.api.nvim_create_augroup
      :search-and-replace
      {:clear true})
   autocmd vim.api.nvim_create_autocmd]
  (autocmd
    :InsertEnter
    {:command "setlocal nohlsearch"
     :group augroup})
  (autocmd
    :InsertLeave
    {:command "setlocal hlsearch"
     :group augroup}))
