(let [g vim.g]
  ; Conjure
  (set g.conjure#completion#omnifunc :v:lua.vim.lsp.omnifunc)

  ; MUcomplete
  (set g.mucomplete#buffer_relative_paths true)
  (set g.mucomplete#chains {:default [:omni :path]})
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
  (set g.templates_no_builtin_templates true))

; Autopairs

(let [{: setup} (require :nvim-autopairs)] (setup {:disable_filetype [:fnl]}))

; Context

(let [{: setup} (require :nvim_context_vt)]
  (setup
    {:disable_virtual_lines true
     :min_rows 10
     :prefix ""}))

; Leap

(let [{: setup : add_repeat_mappings} (require :leap)]
  (setup
    {:opts
     {:special_keys
      {:prev_group :<backspace>
       :prev_target :<backspace>}}})
  (add_repeat_mappings ";" "," {:relative_directions true})
  (vim.keymap.set :n :gw "<Plug>(leap-from-window)"))
(let [{: setup} (require :flit)] (setup {:labeled_modes :nvo}))

; MiniComment

(let [{: setup} (require :mini.comment)]
  (setup {:options {:ignore_blank_line true}}))

; MiniIndentscope

(let [{: draw : setup : undraw} (require :mini.indentscope)]
  (setup
    {:options {:border :top}
     :symbol :│})
  (set vim.g.miniindentscope_disable true)
  (vim.api.nvim_create_autocmd
    :InsertEnter
    {:callback
      (fn []
        (when (not vim.g.miniindentscope_disable)
          (set vim.g.miniindentscope_disable true)
          (undraw)))
     :group (vim.api.nvim_create_augroup :indentscope {:clear true})})
  (vim.keymap.set :n :si
    (fn []
      (let [new-status (not vim.g.miniindentscope_disable)]
        (set vim.g.miniindentscope_disable new-status)
        (if new-status (undraw) (draw))))))

; MiniSurround

(let [{: setup} (require :mini.surround)]
  (setup
    {:mappings {:replace :sc}
     :silent true}))

; Noice

(let [{: setup} (require :noice)]
  (setup
    {:cmdline
     {:format
      {:cmdline {:title ""}
       :input {:title ""}
       :lua {:title ""}
       :search_down {:title ""}
       :search_up {:title ""}}}
     :health {:checker false}
     :lsp
     {:override
      {:vim.lsp.util.convert_input_to_markdown_lines true
       :vim.lsp.util.stylize_markdown true}}
     :popupmenu {:kind_icons (require :kind-icons)}
     :views
     {:confirm {:border {:text {:top ""}}}
      :hover {:border {:padding [1 1]}}
      :mini {:border {:padding [1 1]}}}}))

; Octo

(let [{: setup} (require :octo)] (setup))

; Project

(let [{: setup} (require :project_nvim)]
  (setup
    {:patterns [:.git :.pijul :shell.nix]
     :show_hidden true}))

; Undotree

(let [{: setup : toggle} (require :undotree)]
  (setup
    {:float_diff false
     :keymaps {:a :action_enter}})
  (vim.api.nvim_create_user_command
    :Undotree
    (fn [] (vim.cmd "tabedit %") (toggle))
    {}))

(let [tap-dance (require :tap-dance)]
  (tap-dance
    {:b "<Plug>(leap-backward-to)"
     :e "<Plug>(leap-forward-to)"
     :h :F
     :j :f
     :k :F
     :l :f
     :w "<Plug>(leap-forward-to)"}
    [:n :x]
    1))
