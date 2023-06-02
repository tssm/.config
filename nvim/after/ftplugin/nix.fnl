(let [{: repo} (require :procedures)]
  (vim.lsp.start
    {:cmd [:nil]
     :filetypes [:nix]
     :root_dir (repo (vim.api.nvim_buf_get_name 0))
     :settings
     {:nil {:formatting {:command [:nixpkgs-fmt]}}}}))
