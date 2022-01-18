self: super:

let
  plug = user: repo: super.vimUtils.buildVimPlugin {
    name =
      if repo == "nvim" || repo == "vim"
      then user
      else
        (builtins.replaceStrings
          [ "vim-" "nvim-" "-vim" "-nvim" ".vim" ".nvim" ]
          [ "" "" "" "" "" "" ]
          repo
        );
    src = fetchGit { url = "git@github.com:${user}/${repo}"; ref = "HEAD"; };
    buildPhase = ":";
  };
in
{
  neovim = super.neovim.override {
    configure = {
      customRC = "luafile ~/.config/nvim/init.lua";
      packages.myVimPackages = {
        start = [
          # Color schemes with special initialization
          (plug "catppuccin" "nvim")
          (plug "EdenEast" "nightfox.nvim")
          (plug "rose-pine" "neovim")
          (plug "folke" "tokyonight.nvim")

          # General
          (plug "rmagatti" "auto-session")
          (plug "moll" "vim-bbye")
          (plug "norcalli" "nvim-colorizer.lua")
          (plug "tpope" "vim-commentary")
          (plug "mfussenegger" "nvim-dap")
          (
            super.vimUtils.buildVimPlugin {
              name = "difforig";
              src = fetchGit "https://github.com/lifecrisis/vim-difforig";
              buildPhase = ":";
              patches = [ ./difforig-mapcheck.patch ];
            }
          )
          (plug "editorconfig" "editorconfig-vim")
          (plug "rhysd" "git-messenger.vim")
          (plug "phaazon" "hop.nvim")
          (plug "kosayoda" "nvim-lightbulb")
          (plug "AndrewRadev" "linediff.vim")
          (plug "samoshkin" "vim-mergetool")
          (plug "lifepillar" "vim-mucomplete")
          (plug "pwntester" "octo.nvim")
          (plug "kristijanhusak" "orgmode.nvim")
          (
            super.vimUtils.buildVimPlugin {
              name = "project";
              src = fetchGit { url = "https://github.com/ahmedkhalf/project.nvim"; ref = "HEAD"; };
              buildPhase = ":";
              patches = [ ./stop-project.patch ];
            }
          )
          (plug "tssm" "nvim-random-colors")
          (plug "tssm" "nvim-reflex")
          (plug "tpope" "vim-repeat")
          (plug "machakann" "vim-sandwich")
          (plug "mhinz" "vim-signify")
          (plug "tpope" "vim-sleuth")
          (plug "tssm" "nvim-snitch")
          (plug "aperezdc" "vim-template")
          (plug "mbbill" "undotree")

          # Dirvish
          (plug "justinmk" "vim-dirvish")
          (plug "kristijanhusak" "vim-dirvish-git")

          # Lexima
          (plug "cohama" "lexima.vim")
          (plug "zandrmartin" "lexima-template-rules")

          # LSP
          (plug "neovim" "nvim-lspconfig")
          (plug "nanotee" "sqls.nvim")

          # Telescope
          (plug "nvim-lua" "plenary.nvim")
          (plug "nvim-lua" "popup.nvim")
          (plug "nvim-telescope" "telescope.nvim")
          (plug "rmagatti" "session-lens")

          # Tree-sitter
          (plug "nvim-treesitter" "nvim-treesitter")
          (super.pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: super.pkgs.tree-sitter.allGrammars))
          (plug "nvim-treesitter" "nvim-treesitter-refactor")
          (plug "nvim-treesitter" "nvim-treesitter-textobjects")

          # File types
          (plug "vmchale" "dhall-vim")
          (plug "lifepillar" "pgsql.vim")
          (plug "purescript-contrib" "purescript-vim")

          # Fennel
          (plug "Olical" "aniseed")
          (plug "Olical" "conjure")

          # Haskell
          (plug "zenzike" "vim-haskell-unicode")
          (plug "pbrisbin" "vim-syntax-shakespeare")
        ];
        opt = [
          # Color schemes
          (plug "ayu-theme" "ayu-vim")
          (plug "thenewvu" "vim-colors-blueprint")
          (plug "tssm" "c64-vim-color-scheme")
          (plug "challenger-deep-theme" "vim")
          (plug "Jimeno0" "vim-chito")
          (plug "wadackel" "vim-dogrun")
          (plug "tssm" "fairyfloss.vim")
          (plug "charlespeters" "ganymede.vim")
          (plug "whatyouhide" "vim-gotham")
          (plug "morhetz" "gruvbox")
          (plug "kaicataldo" "material.vim")
          (plug "franbach" "miramare")
          (plug "icymind" "NeoSolarized")
          (plug "tssm" "nemo")
          (plug "haishanh" "night-owl.vim")
          (plug "arcticicestudio" "nord-vim")
          (plug "trevordmiller" "nova-vim")
          (plug "adrian5" "oceanic-next-vim")
          (plug "connorholyday" "vim-snazzy")
          (plug "nightsense" "snow")
          (plug "tssm" "strawberry")
          (plug "jsit" "toast.vim")
          (plug "tssm" "wonka")
        ];
      };
    };
  };

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (
    oldAttrs: {
      src = fetchGit https://github.com/neovim/neovim;
      buildInputs = oldAttrs.buildInputs ++ [ super.pkgs.tree-sitter ];
      version = "head";
    }
  );
}
