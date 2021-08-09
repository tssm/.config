self: super:

let
  plug = name: user: repo: super.vimUtils.buildVimPlugin {
    name = name;
    src = fetchGit "git@github.com:${user}/${repo}";
    buildPhase = ":";
  };
in
{
  neovim = super.neovim.override {
    configure = {
      customRC = "luafile ~/.config/nvim/init.lua";
      packages.myVimPackages = {
        start = [
          # General
          (plug "auto-session" "rmagatti" "auto-session")
          (plug "bbye" "moll" "vim-bbye")
          (plug "colorizer" "norcalli" "nvim-colorizer.lua")
          (plug "commentary" "tpope" "vim-commentary")
          (plug "dap" "mfussenegger" "nvim-dap")
          (
            super.vimUtils.buildVimPlugin {
              name = "difforig";
              src = fetchGit "https://github.com/lifecrisis/vim-difforig";
              buildPhase = ":";
              patches = [ ./difforig-mapcheck.patch ];
            }
          )
          (plug "dirvish" "justinmk" "vim-dirvish")
          (plug "editorconfig" "editorconfig" "editorconfig-vim")
          (plug "git-messenger" "rhysd" "git-messenger.vim")
          (plug "hop" "phaazon" "hop.nvim")
          (plug "lightbulb" "kosayoda" "nvim-lightbulb")
          (plug "linediff" "AndrewRadev" "linediff.vim")
          (plug "mergetool" "samoshkin" "vim-mergetool")
          (plug "mucomplete" "lifepillar" "vim-mucomplete")
          (plug "orgmode" "kristijanhusak" "orgmode.nvim")
          (plug "random-colors" "tssm" "nvim-random-colors")
          (plug "reflex" "tssm" "nvim-reflex")
          (plug "repeat" "tpope" "vim-repeat")
          (plug "rooter" "airblade" "vim-rooter")
          (plug "sandwich" "machakann" "vim-sandwich")
          (plug "signify" "mhinz" "vim-signify")
          (plug "sleuth" "tpope" "vim-sleuth")
          (plug "snitch" "tssm" "nvim-snitch")
          (plug "template" "aperezdc" "vim-template")
          (plug "undotree" "mbbill" "undotree")

          # Dadbod
          (plug "dadbod" "tpope" "vim-dadbod")
          (plug "dadbod-completion" "kristijanhusak" "vim-dadbod-completion")

          # Lexima
          (plug "lexima" "cohama" "lexima.vim")
          (plug "lexima-template-rules" "zandrmartin" "lexima-template-rules")

          # LSP
          (plug "lspconfig" "neovim" "nvim-lspconfig")

          # Telescope
          (plug "plenary" "nvim-lua" "plenary.nvim")
          (plug "popup" "nvim-lua" "popup.nvim")
          (plug "telescope" "nvim-telescope" "telescope.nvim")
          (plug "session-lens" "rmagatti" "session-lens")

          # Tree-sitter
          (plug "tree-sitter" "nvim-treesitter" "nvim-treesitter")
          (super.pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: super.pkgs.tree-sitter.allGrammars))
          (plug "tree-sitter-refactor" "nvim-treesitter" "nvim-treesitter-refactor")
          (plug "tree-sitter-textobjects" "nvim-treesitter" "nvim-treesitter-textobjects")

          # File types
          (plug "dhall" "vmchale" "dhall-vim")
          (plug "pgsql" "lifepillar" "pgsql.vim")
          (plug "purescript" "purescript-contrib" "purescript-vim")

          # Fennel
          (plug "aniseed" "Olical" "aniseed")
          (plug "conjure" "Olical" "conjure")

          # Haskell
          (plug "haskell-unicode" "zenzike" "vim-haskell-unicode")
          (plug "shakespeare" "pbrisbin" "vim-syntax-shakespeare")
        ];
        opt = [
          # Color schemes
          (plug "ayu" "ayu-theme" "ayu-vim")
          (plug "blueprint" "thenewvu" "vim-colors-blueprint")
          (plug "c64" "tssm" "c64-vim-color-scheme")
          (plug "challenger-deep" "challenger-deep-theme" "vim")
          (plug "chito" "Jimeno0" "vim-chito")
          (plug "dogrun" "wadackel" "vim-dogrun")
          (plug "fairyfloss" "tssm" "fairyfloss.vim")
          (plug "ganymede" "charlespeters" "ganymede.vim")
          (plug "gotham" "whatyouhide" "vim-gotham")
          (plug "gruvbox" "morhetz" "gruvbox")
          (plug "material" "kaicataldo" "material.vim")
          (plug "miramare" "franbach" "miramare")
          (plug "night-owl" "haishanh" "night-owl.vim")
          (plug "nord" "arcticicestudio" "nord-vim")
          (plug "nova" "trevordmiller" "nova-vim")
          (plug "oceanic-next" "mhartington" "oceanic-next")
          (plug "pink-moon" "sts10" "vim-pink-moon")
          (plug "snazzy" "connorholyday" "vim-snazzy")
          (plug "snow" "nightsense" "snow")
          (plug "strawberry" "nightsense" "strawberry")
          (plug "toast" "jsit" "toast.vim")
        ];
      };
    };
  };

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (
    oldAttrs: {
      src = fetchGit "https://github.com/neovim/neovim";
      version = "head";
    }
  );
}
