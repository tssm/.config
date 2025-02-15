self: super:

let
  plug = user: repo: patches: super.vimUtils.buildVimPlugin {
    doCheck = false;
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
          # General
          (plug "moll" "vim-bbye" [ ])
          (plug "norcalli" "nvim-colorizer.lua" [ ])
          (plug "Olical" "conjure" [ ])
          (plug "mfussenegger" "nvim-dap" [ ])
          (plug "whiteinge" "diffconflicts" [ ])
          (plug "lifecrisis" "vim-difforig" [ ./difforig-mapcheck.patch ])
          (plug "justinmk" "vim-dirvish" [ ])
          (plug "ibhagwan" "fzf-lua" [
            ./fzf-lua-help-in-current-window.patch
            ./fzf-lua-ivy-preview-always-at-bottom.patch
          ])
          (plug "lewis6991" "gitsigns.nvim" [ ])
          (plug "kosayoda" "nvim-lightbulb" [ ])
          (plug "AndrewRadev" "linediff.vim" [ ])
          (plug "echasnovski" "mini.nvim" [ ])
          (plug "tssm" "nvim-reflex" [ ])
          (plug "tssm" "sessionmatic" [ ])
          (plug "tpope" "vim-sleuth" [ ])
          (plug "tssm" "nvim-snitch" [ ])
          (plug "tssm" "tap-dance" [ ])
          (plug "aperezdc" "vim-template" [ ])
          (plug "jiaoshijie" "undotree" [ ])

          # Flit
          (plug "ggandor" "flit.nvim" [ ])
          (plug "ggandor" "leap.nvim" [ ])
          (plug "tpope" "vim-repeat" [ ])

          # Noice
          (plug "folke" "noice.nvim" [ ])
          (plug "MunifTanjim" "nui.nvim" [ ])

          # Octo
          (plug "pwntester" "octo.nvim" [ ])
          (plug "nvim-lua" "plenary.nvim" [ ])

          # Tree-sitter
          super.pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          (plug "nvim-treesitter" "nvim-treesitter-refactor" [ ./tree-sitter-refactor.patch ])
          (plug "nvim-treesitter" "nvim-treesitter-textobjects" [ ])
          (plug "windwp" "nvim-autopairs" [ ])
          (plug "windwp" "nvim-ts-autotag" [ ])
          (plug "haringsrob" "nvim_context_vt" [ ])

          # Fennel
          (plug "gpanders" "nvim-parinfer" [ ])

          # Haskell
          (plug "zenzike" "vim-haskell-unicode" [ ])
          (plug "pbrisbin" "vim-syntax-shakespeare" [ ])
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
