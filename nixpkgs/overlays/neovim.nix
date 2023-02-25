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
          (plug "maxmx03" "FluoroMachine.nvim" [ ])
          (plug "rebelot" "kanagawa.nvim" [ ])
          (plug "katawful" "kat.nvim" [ ])
          (plug "savq" "melange" [ ])
          (plug "rose-pine" "neovim" [ ])

          # General
          (plug "f-person" "auto-dark-mode.nvim" [ ])
          (plug "moll" "vim-bbye" [ ])
          (plug "norcalli" "nvim-colorizer.lua" [ ])
          (plug "terrortylor" "nvim-comment" [ ])
          (plug "mfussenegger" "nvim-dap" [ ])
          (plug "whiteinge" "diffconflicts" [ ])
          (plug "lifecrisis" "vim-difforig" [ ./difforig-mapcheck.patch ])
          (plug "justinmk" "vim-dirvish" [ ])
          (plug "editorconfig" "editorconfig-vim" [ ])
          (plug "stonelasley" "flare.nvim" [ ])
          (plug "ibhagwan" "fzf-lua" [
            ./fzf-lua-do-not-open-qf-list.patch
            ./fzf-lua-help-in-current-window.patch
            ./fzf-lua-remove-header.patch
          ])
          (plug "rhysd" "git-messenger.vim" [ ])
          (plug "phaazon" "hop.nvim" [ ])
          (plug "kosayoda" "nvim-lightbulb" [ ])
          (plug "AndrewRadev" "linediff.vim" [ ])
          (plug "lifepillar" "vim-mucomplete" [ ])
          (plug "ahmedkhalf" "project.nvim" [ ./stop-project.patch ])
          (plug "tssm" "nvim-random-colors" [ ])
          (plug "tssm" "nvim-reflex" [ ])
          (plug "tssm" "sessionmatic" [ ])
          (plug "machakann" "vim-sandwich" [ ])
          (plug "mhinz" "vim-signify" [ ])
          (plug "tpope" "vim-sleuth" [ ])
          (plug "tssm" "nvim-snitch" [ ])
          (plug "aperezdc" "vim-template" [ ])
          (plug "mbbill" "undotree" [ ])
          (plug "kyazdani42" "nvim-web-devicons" [ ])

          # LSP
          (plug "joechrisellis" "lsp-format-modifications.nvim" [ ])
          (plug "nanotee" "sqls.nvim" [ ])

          # Noice
          (plug "folke" "noice.nvim" [ ])
          (plug "MunifTanjim" "nui.nvim" [ ])

          # Octo
          (plug "pwntester" "octo.nvim" [ ])
          (plug "nvim-lua" "plenary.nvim" [ ])
          (plug "nvim-telescope" "telescope.nvim" [ ])

          # Tree-sitter
          (plug "nvim-treesitter" "nvim-treesitter" [ ])
          super.pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          (plug "nvim-treesitter" "nvim-treesitter-refactor" [ ./tree-sitter-refactor.patch ])
          (plug "nvim-treesitter" "nvim-treesitter-textobjects" [ ])
          (plug "windwp" "nvim-autopairs" [ ])
          (plug "windwp" "nvim-ts-autotag" [ ])
          (plug "haringsrob" "nvim_context_vt" [ ])

          # File types
          (plug "vmchale" "dhall-vim" [ ])
          (plug "purescript-contrib" "purescript-vim" [ ])

          # Fennel
          (plug "Olical" "aniseed" [ ])
          (plug "Olical" "conjure" [ ])
          (plug "gpanders" "nvim-parinfer" [ ])

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
