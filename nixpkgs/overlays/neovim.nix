self: super:

let
  plug = user: repo: patches: super.vimUtils.buildVimPlugin {
    patches = patches;
    pname =
      if repo == "nvim" || repo == "vim"
      then user
      else
        (builtins.replaceStrings
          [ "vim-" "nvim-" "nvim_" "-vim" "-nvim" ".vim" ".nvim" ]
          [ "" "" "" "" "" "" "" ]
          repo
        );
    src = fetchGit { url = "git@github.com:${user}/${repo}"; ref = "HEAD"; };
    buildPhase = ":";
    version = "HEAD";
  };
in
{
  neovim = super.neovim.override {
    configure = {
      customRC = "luafile ~/.config/nvim/init.lua";
      packages.myVimPackages = {
        start = [
          # Color schemes with special initialization
          (plug "sainnhe" "everforest" [ ])
          (plug "rose-pine" "neovim" [ ])
          (plug "folke" "tokyonight.nvim" [ ])

          # General
          (plug "moll" "vim-bbye" [ ])
          (plug "norcalli" "nvim-colorizer.lua" [ ])
          (plug "tpope" "vim-commentary" [ ])
          (plug "mfussenegger" "nvim-dap" [ ])
          (plug "lifecrisis" "vim-difforig" [ ./difforig-mapcheck.patch ])
          (plug "justinmk" "vim-dirvish" [ ])
          (plug "editorconfig" "editorconfig-vim" [ ])
          (plug "rhysd" "git-messenger.vim" [ ])
          (plug "phaazon" "hop.nvim" [ ])
          (plug "kosayoda" "nvim-lightbulb" [ ])
          (plug "AndrewRadev" "linediff.vim" [ ])
          (plug "samoshkin" "vim-mergetool" [ ])
          (plug "lifepillar" "vim-mucomplete" [ ])
          (plug "pwntester" "octo.nvim" [ ])
          (plug "kristijanhusak" "orgmode.nvim" [ ])
          (plug "ahmedkhalf" "project.nvim" [ ./stop-project.patch ])
          (plug "tssm" "nvim-random-colors" [ ])
          (plug "tssm" "nvim-reflex" [ ])
          (plug "tpope" "vim-repeat" [ ])
          (plug "tssm" "sessionmatic" [ ])
          (plug "machakann" "vim-sandwich" [ ])
          (plug "mhinz" "vim-signify" [ ])
          (plug "tpope" "vim-sleuth" [ ])
          (plug "tssm" "nvim-snitch" [ ])
          (plug "aperezdc" "vim-template" [ ])
          (plug "mbbill" "undotree" [ ])
          (plug "kyazdani42" "nvim-web-devicons" [ ])

          # LSP
          (plug "j-hui" "fidget.nvim" [ ])
          (plug "neovim" "nvim-lspconfig" [ ])
          (plug "nanotee" "sqls.nvim" [ ])

          # Telescope
          (plug "nvim-lua" "plenary.nvim" [ ])
          (plug "nvim-lua" "popup.nvim" [ ])
          (plug "nvim-telescope" "telescope.nvim" [ ./telescope-help.patch ])
          (plug "nvim-telescope" "telescope-ui-select.nvim" [ ])

          # Tree-sitter
          (plug "nvim-treesitter" "nvim-treesitter" [ ])
          (super.pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: super.pkgs.tree-sitter.allGrammars))
          (plug "nvim-treesitter" "nvim-treesitter-refactor" [ ])
          (plug "nvim-treesitter" "nvim-treesitter-textobjects" [ ])
          (plug "windwp" "nvim-autopairs" [ ])
          (plug "windwp" "nvim-ts-autotag" [ ])
          (plug "haringsrob" "nvim_context_vt" [ ])

          # File types
          (plug "vmchale" "dhall-vim" [ ])
          (plug "lifepillar" "pgsql.vim" [ ])
          (plug "purescript-contrib" "purescript-vim" [ ])

          # Fennel
          (plug "Olical" "aniseed" [ ])
          (plug "Olical" "conjure" [ ])

          # Haskell
          (plug "zenzike" "vim-haskell-unicode" [ ])
          (plug "pbrisbin" "vim-syntax-shakespeare" [ ])
        ];
        opt = [
          # Color schemes
          (plug "thenewvu" "vim-colors-blueprint" [ ])
          (plug "tssm" "c64-vim-color-scheme" [ ])
          (plug "tssm" "fairyfloss.vim" [ ])
          (plug "charlespeters" "ganymede.vim" [ ])
          (plug "savq" "melange" [ ])
          (plug "tssm" "strawberry" [ ])
          (plug "jsit" "toast.vim" [ ])
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
