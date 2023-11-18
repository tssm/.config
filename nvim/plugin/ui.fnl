; Fix color schemes

(fn fix-color-schemes []
  (let
    [get-hl (fn [name] (vim.api.nvim_get_hl 0 {:name name}))
     set-hl (fn [name value] (vim.api.nvim_set_hl 0 name value))
     {:bg normal-bg} (get-hl :Normal)
     {:bg sl-bg :fg sl-fg :reverse sl-reverse} (get-hl :StatusLineNC)
     extend-hl
       (fn [name extension]
         (let
           [definition (get-hl name)
            extended (vim.tbl_extend :force definition extension)]
           (set-hl name extended)))]
    (each
      [name extension
        (pairs
          {:EndOfBuffer {:bg normal-bg :fg normal-bg}
           :FoldColumn {:bg normal-bg}
           :SignColumn {:bg normal-bg}
           :SpecialKey {:bg normal-bg}
           :StatusLine {:bg (if sl-reverse sl-fg sl-bg) :fg (. (get-hl :Identifier) :fg) :bold true}
           :TermCursorNC {:bg normal-bg :fg normal-bg}
           :WinSeparator {:bg normal-bg :fg (if sl-reverse sl-fg sl-bg)}})]
      (extend-hl name extension))
    (each
      [name link
        (pairs
          {:Folded :FoldColumn
           ; Plug-ins
           :ContextVt :NonText
           :LeapBackdrop :NonText
           :MiniJump2dSpot :Search
           :NoiceConfirmBorder :WinSeparator
           :NoiceCmdlinePopupBorder :NoiceConfirmBorder
           :NoiceCmdlinePopupBorderSearch :NoiceConfirmBorder
           :NoiceSplit :Normal})]
      (set-hl name {:link link}))))

; Autocommands

(let
  [augroup (vim.api.nvim_create_augroup :ui {:clear true})
   autocmd vim.api.nvim_create_autocmd]
  (autocmd
    [:BufEnter :TermOpen :WinEnter]
    {:command "setlocal statusline=%{%v:lua.require'status-line'(v:true)%}"
     :group augroup})
  (autocmd
    [:BufLeave :WinLeave]
    {:command "setlocal statusline=%{%v:lua.require'status-line'(v:false)%}"
     :group augroup})
  (autocmd
    :ColorScheme
    {:callback fix-color-schemes
     :group augroup}))

; Set options

(let [opt vim.opt]
  (set opt.fillchars {:fold " "})
  (set opt.guicursor
    "n-v:block,i-c-ci-ve:ver35,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon600-Cursor")
  (set opt.guifont "JetBrainsMonoNL Nerd Font Mono:h13")
  (set opt.list true)
  (set opt.listchars {:extends :… :precedes :… :tab "  "})
  (set opt.showcmdloc :statusline)
  (set opt.showmatch true)
  (set opt.showmode false)
  (set opt.showtabline 0)
  (set opt.termguicolors true))

; Set random scheme

(vim.cmd "colorscheme randomhue")
