(fn [markers]
  (vim.fs.root 0
    (vim.tbl_extend :keep markers [:.git :.pijul :shell.nix])))
