(let [g vim.g]
  ; Conjure
  (set g.conjure#completion#omnifunc :v:lua.vim.lsp.omnifunc)

  ; Git Messenger
  (set g.git_messenger_no_default_mappings true)
  (set g.git_messenger_always_into_popup true)

  ; MUcomplete
  (set g.mucomplete#buffer_relative_paths true)
  (set g.mucomplete#chains {:default [:omni :path :uspl]})
  (set g.mucomplete#enable_auto_at_startup true)
  (set g.mucomplete#minimum_prefix_length 0)
  (set vim.opt.completeopt [:menuone :noinsert])

  ; Parinfer
  (set g.parinfer_no_maps true)

  ; Reflex
  (set g.reflex_delete_buffer_cmd :Bwipeout!)
  (set g.reflex_delete_file_cmd :trash)

  ; Templates
  (set g.templates_directory [(.. (vim.fn.stdpath :config) :/templates)])
  (set g.templates_global_name_prefix :template.)
  (set g.templates_no_builtin_templates true)

  ; Undotree
  (set g.undotree_HelpLine false)
  (set g.undotree_SetFocusWhenToggle true))

; Auto-dark-mode

(let [auto-dark-mode (require :auto-dark-mode)]
  (auto-dark-mode.setup)
  (auto-dark-mode.init))

; Autopairs

(let [{: setup} (require :nvim-autopairs)] (setup {:disable_filetype [:fnl]}))

; Context

(let [{: setup} (require :nvim_context_vt)]
  (setup
    {:disable_virtual_lines true
     :min_rows 10
     :prefix :}))

; MiniComment

(let [{: setup} (require :mini.comment)]
  (setup {:options {:ignore_blank_line true}}))

; MiniIndentscope

(let [{: setup} (require :mini.indentscope)]
  (setup
    {:options {:border :top}
     :symbol :│}))

; MiniSurround

(let [{: setup} (require :mini.surround)]
  (setup
    {:mappings {:replace :sc}
     :silent true}))

; Noice

(let [{: setup} (require :noice)]
  (setup
    {:lsp
     {:override
      {:vim.lsp.util.convert_input_to_markdown_lines true
       :vim.lsp.util.stylize_markdown true}}
     :popupmenu {:kind_icons (require :kind-icons)}
     :views {:hover {:border {:padding [1 1]}}}}))

; Octo

(let [{: setup} (require :octo)] (setup))

; Project

(let [{: setup} (require :project_nvim)]
  (setup
    {:ignore_lsp [:sqls]
     :patterns [:.git :.pijul :shell.nix]
     :show_hidden true}))
