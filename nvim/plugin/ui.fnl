; Configure color schemes

(set vim.g.ganymede_solid_background true)

; Fix color schemes

(fn fix-color-schemes []
  (local call vim.fn)
  (local status-line-highlight (call.execute "highlight StatusLineNC"))
  (local reversed?
    (not=
      (call.matchstr
        status-line-highlight
        "gui=\\(\\w*,\\)*\\(inverse\\|reverse\\)\\(,\\w*\\)*")
      ""))
  (local split-color (call.matchstr status-line-highlight (.. :gui (if reversed? :fg :bg) "=\\zs\\S*")))
  (call.execute (string.format "highlight! VertSplit guibg=bg guifg=%s gui=NONE cterm=NONE" split-color))

  (local highlights
    ["EndOfBuffer guibg=bg guifg=bg"
     "FoldColumn guibg=bg"
     "link Folded FoldColumn"
     "SignColumn guibg=bg"
     "SpecialKey guibg=bg"
     "TermCursorNC guibg=bg guifg=bg"
     ; Plugins
     "link HopCursor Cursor"
     "link HopNextKey Search"
     "link HopNextKey1 HopNextKey"
     "link HopNextKey2 NONE"
     "link HopUnmatched NONE"
     "link TelescopeBorder VertSplit"
     "link TelescopeNormal Normal"])

  (each
    [_ highlight (ipairs highlights)]
    (call.execute (string.format "highlight! %s" highlight))))

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

(local opt vim.opt)
(set opt.fillchars {:fold " "})
(set opt.guicursor
  "n-v:block,i-c-ci-ve:ver35,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon600-Cursor")
(set opt.list true)
(set opt.listchars {:extends :… :precedes :… :tab "  "})
(set opt.showmatch true)
(set opt.showmode false)
(set opt.showtabline 0)
(set opt.termguicolors true)


