{ pkgs, ... }: {
  environment.darwinConfig = "$HOME/.config/darwin.nix";
  environment.systemPackages = [
    pkgs.cabal-install
    pkgs.cargo
    pkgs.ccls
    pkgs.darwin.trash
    pkgs.dhall
    pkgs.dhall-json
    pkgs.dhall-lsp-server
    pkgs.diffr
    pkgs.erlang
    pkgs.fd
    pkgs.fish
    pkgs.fzf
    pkgs.gh
    pkgs.ghc
    pkgs.gleam
    pkgs.haskellPackages.haskell-language-server
    pkgs.lua-language-server
    pkgs.luajitPackages.fennel
    pkgs.neovim
    pkgs.neovim-remote
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.pijul
    pkgs.ripgrep
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.tree
  ];

  fonts.fontDir.enable = true;
  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  nix.configureBuildUsers = true;
  nix.settings.cores = 8; # $ sysctl -n hw.ncpu
  nix.settings.max-jobs = 8; # $ sysctl -n hw.ncpu
  nix.settings.min-free = 1000000000;
  nix.settings.trusted-users = [ "@admin" ];

  nixpkgs.config = { allowUnfree = true; };
  nixpkgs.overlays = [ (import nixpkgs/overlays/neovim.nix) ];

  services.nix-daemon.enable = true;
}
