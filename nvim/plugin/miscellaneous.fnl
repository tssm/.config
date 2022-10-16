(local g vim.g)

(fn set-map [mode lhs rhs]
  (vim.api.nvim_set_keymap mode lhs rhs {}))

; Auto-dark-mode

(let [auto-dark-mode (require :auto-dark-mode)]
  (auto-dark-mode.setup)
  (auto-dark-mode.init))

; Autopairs

(
  (. (require :nvim-autopairs) :setup)
  {:disable_filetype [:fnl]})

; Comment

((. (require :nvim_comment) :setup))

; Context

(
  (. (require :nvim_context_vt) :setup)
  {:disable_virtual_lines true
   :min_rows 10
   :prefix :})

; Editorconfig

(set g.EditorConfig_max_line_indicator :none)

; Fidget

((. (require :fidget) :setup) {})

; Git Messenger

(set g.git_messenger_no_default_mappings true)

; MUcomplete

(set g.mucomplete#buffer_relative_paths true)
(set g.mucomplete#chains {:default [:omni :path :uspl]})
(set g.mucomplete#enable_auto_at_startup true)
(set g.mucomplete#minimum_prefix_length 0)
(set vim.opt.completeopt [:menuone :noinsert])

; Octo

((. (require :octo) :setup))

; Parinfer

(set g.parinfer_no_maps true)

; Project

(
  (. (require :project_nvim) :setup)
  {:ignore_lsp [:sqls]
   :patterns [:.git :.pijul :shell.nix]
   :show_hidden true})

; Random colors

(let [random-colors (require :random-colors)]
  (vim.api.nvim_create_user_command
    :RandomColors
    random-colors
    {}))

; Reflex

(set g.reflex_delete_buffer_cmd :Bwipeout!)
(set g.reflex_delete_file_cmd :trash)

; Sandwich

(set-map :n :s "")
(set-map :x :s "")
; Use c as mnemonic for change
(set-map :n :sc
  "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)")
(set-map :n :scb
  "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
(set-map :x :sc "<Plug>(operator-sandwich-replace)")

; Templates

(set g.templates_directory [(.. (vim.fn.stdpath :config) :/templates)])
(set g.templates_global_name_prefix :template.)
(set g.templates_no_builtin_templates true)

; Undotree

(set g.undotree_HelpLine false)
(set g.undotree_SetFocusWhenToggle true)
