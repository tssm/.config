(let [root (require :root)]
  (vim.lsp.start
    {:cmd [:nil]
     :filetypes [:nix]
     :root_dir (root [])
     :settings
     {:nil {:formatting {:command [:nixpkgs-fmt]}}}}))
