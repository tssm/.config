" Behavior {{{

augroup AutoLoadVimrcChanges
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup RestoreCursorShapeOnExit
	autocmd!
	autocmd VimLeave * set guicursor=a:ver35-blinkon1
augroup END

augroup ChangeNumberLineFormatAccordingToFocus
	autocmd!
	autocmd BufEnter,WinEnter *
		\ if &buftype == '' |
		\ 	set number relativenumber |
		\ elseif &buftype ==# 'help' || &buftype ==# 'terminal' |
		\ 	set nonumber relativenumber |
		\ endif
	autocmd TermOpen * set nonumber
	autocmd WinLeave *
		\ if &buftype == '' |
		\ 	set norelativenumber |
		\ endif
augroup END

set clipboard=unnamed,unnamedplus
" Uses the clipboard as the unnamed register

set hidden
" Allows hidden buffers without writing them

set inccommand=split

set iskeyword-=_

set mouse=a

set nojoinspaces
" Use only 1 space after '.' when joining lines

set noshowmode
" Because Neovim's cursor shape

augroup ResizeWindowsProportionally
	autocmd!
	autocmd VimResized * :wincmd =
augroup END

set shortmess=csFS

set visualbell
" Turns off annoying sound

" }}}

" Diff {{{

set diffopt+=vertical

let s:diff_tab=0
function! s:diff_tab()
	if s:diff_tab > 0
		diffoff!
		let s:diff_tab=0
	else
		windo diffthis
		let s:diff_tab=1
	endif
endfunction
command! Difftab call <SID>diff_tab()

" }}}

" Folding {{{

set foldmethod=syntax
" Create folds based on files's syntax

set nofoldenable
" Open folds by default

" }}}

" Mappings {{{

cnoremap <C-A> <Home>
" Go to the beginning of the line
cnoremap <C-B> <Left>
" Go back one character
cnoremap <C-F> <Right>
" Go forward one character
cnoremap ∫ <S-Left>
" Go back one word
cnoremap ƒ <S-Right>
" Go forward one word
cnoremap <C-P> <Up>
" Search prefix backwards
cnoremap <C-N> <Down>
" Search prefix forward
" Makes the command line behave like Fish

nnoremap <cr> <nop>
let mapleader="\<Enter>"

nnoremap <space> <nop>
let maplocalleader="\<Space>"

noremap d "_d
noremap dd "_dd
noremap D "_D
noremap x "_x
noremap X "_X

noremap c "_c
noremap C "_C
noremap s "_s
noremap S "_S

noremap yd d
noremap yD D
noremap ydd dd

xnoremap p "_dP

nnoremap Y y$
" Makes Y behaves like C and D.

nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" Replace the word under cursor.

noremap! <c-\> <esc>
tnoremap <c-\> <c-\><c-n>
tnoremap <esc> <c-\><c-n>

xnoremap <expr> v
	\ (mode() ==# 'v' ? "\<C-V>"
	\ : mode() ==# 'V' ? 'v' : 'V')

" }}}

" Indentation {{{

set tabstop=2
" Number of spaces that a <Tab> in the file counts for

set shiftwidth=0
" Number of spaces to use for each step of indent. 0 = tabstop

" }}}

" Search and replace {{{

set gdefault
" Substitutes all matches on a line by default

set ignorecase
" Ignore case in a pattern

set smartcase
" Override the ignorecase option if the search pattern contains upper case characters

augroup ToggleSearchHighlighting
	autocmd!
	autocmd InsertEnter * setlocal nohlsearch
	autocmd InsertLeave * setlocal hlsearch
augroup END
" Toggles search highlighting off/on according to current mode. Source: http://blog.sanctum.geek.nz/vim-search-highlighting/

" }}}

" Sessions {{{

set sessionoptions=curdir,help,tabpages,winsize

" }}}

" Statusline {{{

function! GetCursorPosition()
	let l:position = getcurpos()

	return IsSpecialBuffer()
		\ ? ''
		\ : '  ' . l:position[1] . '☰' . ' ' . l:position[2] . '☷'
endfunction

function! GetFileStatus()
	let l:filepath = expand('%:p')

	return
		\ ((IsSpecialBuffer() || empty(glob('%')) || !strlen(l:filepath) || (!&readonly && filewritable(filepath)))
			\ ? ''
			\ : '🔒') .
		\ (&modified ? '💡' : '')
endfunction

function! GetFilename()
	let l:filepath = expand('%')

	return
		\ &buftype ==# 'help' ? expand('%:t:r') . ' help' :
		\ &buftype ==# 'terminal' ? b:term_title :
		\ strlen(l:filepath) > 0 ? l:filepath : '🆕'
endfunction

function! GetWarnings()
	let l:indent_by = &shiftwidth == 0 ? &tabstop : &shiftwidth

	return IsSpecialBuffer()
		\ ? ''
		\ :
			\ (&fileformat ==# 'unix'
				\ ? ''
				\ : '   ' . &fileformat) .
			\ (&fileencoding ==# 'utf-8' || &fileencoding == ''
				\ ? ''
				\ : '   ' . &fileencoding) .
			\ (&expandtab
				\ ? '   ' . l:indent_by . ' space' . (l:indent_by == 1 ? '' : 's')
				\ : (&tabstop == 2 ? '' : '   tab stop of ' . &tabstop))
endfunction

function! IsSpecialBuffer()
	return &buftype != ''
endfunction

function! GetWindowNumber()
	return winnr('$') < 3 ? '' : winnr() . ' ∙ '
endfunction

set statusline=
set statusline+=%{GetWindowNumber()}
set statusline+=%{GetFilename()}
set statusline+=%{GetFileStatus()}
set statusline+=%=
set statusline+=%{GetWarnings()}
set statusline+=%{GetCursorPosition()}

" }}}

" Tab pages {{{

set splitbelow
" Creates new horizontal windows at the bottom

set splitright
" Creates new vertical windows at the right

" }}}

" Terminal {{{

command! -nargs=* -complete=shellcmd T vsplit | terminal <args>
" Open the terminal in a vertical split

command! -nargs=1 -complete=dir -bang S %bwipeout<bang> | cd <args> | terminal
" cd into <args> and start a terminal. S is short for shell

set scrollback=-1

" }}}

" User interface {{{

augroup FixColorSchemes
	autocmd!
	autocmd ColorScheme *
		\ highlight EndOfBuffer guibg=bg |
		\ highlight! link LineNr EndOfBuffer |
		\ highlight CursorLineNr guibg=bg guifg=bg |
		\ highlight SignColumn guibg=bg |
		\ highlight SpecialKey guibg=bg |
		\ highlight! link StatusLineNC StatusLine |
		\ highlight TermCursorNC guibg=bg guifg=bg |
		\ highlight VertSplit guibg=bg guifg=bg
augroup END

set fillchars=fold:\ ,stl:_
" Hides the decoration of folds and sets a continuous vertical windows separator

set guicursor+=a:blinkwait700-blinkoff400-blinkon600

set list listchars=extends:…,precedes:…,tab:\ \ 

set numberwidth=3

set showmatch
" Highlight matching braces when cursor is over one of them

set showtabline=0
" Never show the tabline

set termguicolors
" Enable true color

" }}}

" Wildmenu {{{

set wildignore+=.DS_Store,*.log,.nvimrc,Session.vim
" Should be read from global .gitignore
set wildignore+=.vagrant/**,build/**,node_modules/**,tmp/**
" Should be read from project .gitignore
set wildignore+=*.a,*.class,*.gem,*.lock,*.mo,*.o,*.pyc
" Should be read from project .gitignore
set wildignore+=*.gif,*.jpeg,*.jpg,*.pdf,*.png,*.svg,*.xib
" Graphic stuff
set wildignore+=*.lock
" Lock stuff that is part of the project but shouldn't be modified by hand

set wildignorecase
" Use case-insensitive file search in the wildmenu

" }}}

" Wrap {{{

set linebreak
" When wrap is set use the value of breakat to break lines

set breakat=\	\ 
" Break lines only at whitespace

set breakindent
" Indents wrapped text

set nowrap

" }}}

" Packages

let g:loaded_node_provider=0
let g:loaded_python_provider=0
let g:loaded_python3_provider=0
let g:loaded_ruby_provider=0

lua require('plug')

lua plug('https://github.com/tpope/vim-commentary.git', 'general/start/commentary', 'master')
lua plug('https://github.com/lifecrisis/vim-difforig.git', 'general/start/difforig', 'master')
lua plug('https://github.com/whatyouhide/vim-lengthmatters.git', 'general/start/lengthmatters', 'master')

lua plug('https://github.com/cohama/lexima.vim.git', 'lexima/start/lexima', 'master')
lua plug('https://github.com/zandrmartin/lexima-template-rules.git', 'lexima/start/template-rules', 'master')
lua plug('https://github.com/AndrewRadev/linediff.vim.git', 'general/start/linediff', 'master')

lua plug('https://github.com/yssl/QFEnter.git', 'general/start/qfenter', 'master')
lua plug('https://github.com/tpope/vim-repeat.git', 'general/start/repeat', 'master')
lua plug('https://github.com/tpope/vim-sleuth.git', 'general/start/sleuth', 'master')
lua plug('https://github.com/tpope/vim-surround.git', 'general/start/surround', 'master')
lua plug('git@github.com:tssm/tectonic.vim.git', 'general/start/tectonic', 'master')
lua plug('https://github.com/bronson/vim-trailing-whitespace.git', 'general/start/trailing-whitespace', 'master')
lua plug('git@github.com:tssm/vertical-help.vim.git', 'general/start/vertical-help', 'master')

" Color schemes {{{

lua plug('https://github.com/ayu-theme/ayu-vim', 'colors/opt/ayu', 'master')
let g:ayucolor="mirage"

lua plug('https://github.com/dennougorilla/azuki.vim.git', 'colors/opt/azuki', 'master')
lua plug('https://github.com/thenewvu/vim-colors-blueprint.git', 'colors/opt/blueprint', 'master')
lua plug('git@github.com:tssm/c64-vim-color-scheme', 'colors/opt/c64', 'master')
lua plug('https://github.com/Jimeno0/vim-chito.git', 'colors/opt/chito', 'master')
lua plug('https://github.com/agreco/vim-citylights.git', 'colors/opt/citylights', 'master')
lua plug('https://github.com/archSeer/colibri.vim.git', 'colors/opt/colibri', 'master')
lua plug('git@github.com:tssm/fairyfloss.vim', 'colors/opt/fairyfloss', 'master')
lua plug('https://github.com/whatyouhide/vim-gotham.git', 'colors/opt/gotham', 'master')
lua plug('https://github.com/MaxSt/FlatColor.git', 'colors/opt/flat', 'master')

lua plug('https://github.com/charlespeters/ganymede.vim.git', 'colors/opt/ganymede', 'master')
let g:ganymede_solid_background=1

lua plug('https://github.com/aereal/vim-colors-japanesque.git', 'colors/opt/japanesque', 'master')
lua plug('https://github.com/kaicataldo/material.vim', 'colors/opt/material', 'master')
lua plug('https://github.com/haishanh/night-owl.vim.git', 'colors/opt/night-owl', 'master')
lua plug('https://github.com/trevordmiller/nova-vim.git', 'colors/opt/nova', 'master')
lua plug('https://github.com/KKPMW/oldbook-vim.git', 'colors/opt/oldbook', 'master')
lua plug('https://github.com/sts10/vim-pink-moon.git', 'colors/opt/pink-moon', 'master')
lua plug('https://github.com/KKPMW/sacredforest-vim.git', 'colors/opt/sacredforest', 'master')
lua plug('https://github.com/skreek/skeletor.vim.git', 'colors/opt/skeletor', 'master')
lua plug('https://github.com/connorholyday/vim-snazzy.git', 'colors/opt/snazzy', 'master')
lua plug('https://github.com/nightsense/snow.git', 'colors/opt/snow', 'master')
lua plug('https://github.com/nightsense/stellarized.git', 'colors/opt/stellarized', 'master')
lua plug('https://github.com/nightsense/strawberry.git', 'colors/opt/strawberry', 'master')
lua plug('https://github.com/rupertqin/ThyName.git', 'colors/opt/thyname', 'master')
lua plug('https://github.com/cseelus/vim-colors-tone.git', 'colors/opt/tone', 'master')

" }}}

" Clap {{{

lua plug('https://github.com/liuchengxu/vim-clap.git', 'general/start/clap', 'master', './install.sh')

let g:clap_layout={
	\ 'relative': 'window',
	\ 'col': 0,
	\ 'row': 1,
	\ 'width': '100%',
	\ }

let g:clap_provider_grep_opts='--hidden --glob=!.git/ --glob=!.pijul/ --no-heading --trim --smart-case --vimgrep --with-filename'

nnoremap <silent> <leader>b :Clap buffers ++externalfilter=fzy<cr>

nnoremap <silent> <leader>f :Clap files ++externalfilter=fzy ++finder=rg --files --hidden --glob='!.git/*' --glob='!.pijul/*'<cr>

nnoremap <silent> <leader>g :Clap grep<cr>

" }}}

" Colorize {{{

lua plug('https://github.com/chrisbra/color_highlight.git', 'general/start/colorizer', 'master')

let g:colorizer_colornames=0

let g:colorizer_disable_bufleave=1

let g:colorizer_skip_comments=1

" }}}

" Editorconfig {{{

lua plug('https://github.com/editorconfig/editorconfig-vim.git', 'general/start/editorconfig', 'master')

let g:EditorConfig_max_line_indicator="none"
" Lengthmatters takes care of this

" }}}

" FileBeagle {{{

lua plug('https://github.com/jeetsukumaran/vim-filebeagle.git', 'general/start/filebeagle', 'master')

command! -nargs=1 -complete=dir -bang E %bwipeout<bang> | cd <args> | FileBeagle
" cd into <args> and start FileBeagle. E is short for explore

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let g:filebeagle_suppress_keymaps = 1
nmap <silent> - <Plug>FileBeagleOpenCurrentBufferDir
nmap <silent> _ <Plug>FileBeagleOpenCurrentWorkingDir

let g:filebeagle_check_gitignore = 1

" }}}

" Indexed search {{{

lua plug('https://github.com/henrik/vim-indexed-search.git', 'general/start/indexed-search', 'master')

let g:indexed_search_center=1

" }}}

" {{{ Language Client

lua plug('https://github.com/autozimu/LanguageClient-neovim.git', 'general/start/languageclient', 'next', 'bash install.sh')

autocmd User LanguageClientStarted |
	\ set signcolumn=yes |
	\ nnoremap <buffer> <silent> <c-]> :call LanguageClient#textDocument_definition()<cr> |
	\ nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr> |
	\ nnoremap <buffer> <silent> <f6> :call LanguageClient_textDocument_documentSymbol()<cr> |
	\ nnoremap <buffer> <silent> <leader>e :call LanguageClient#explainErrorAtPoint()<cr>
autocmd User LanguageClientStopped |
	\ set signcolumn=auto |
	\ nunmap <c-]> |
	\ nunmap K |
	\ nunmap <f6>

let g:LanguageClient_autoStart = 1

let g:LanguageClient_diagnosticsDisplay = {
	\ 1: {
		\ "name": "Error",
		\ "signText": "⛔",
	\ },
	\ 2: {
		\ "name": "Warning",
		\ "signText": "⚠️",
	\ },
	\ 3: {
		\ "name": "Information",
		\ "signText": "ℹ️",
	\ },
	\ 4: {
		\ "name": "Hint",
		\ "signText": "💡",
	\ }
\ }

let g:LanguageClient_diagnosticsList="Disabled"

let g:LanguageClient_rootMarkers = {
	\ 'haskell': ['*.cabal'],
	\ 'lua': ['.luacompleterc'],
	\ 'purescript': ['psc-package.json', 'spago.dhall'],
	\ 'rust': ['Cargo.toml'],
	\ }

let g:LanguageClient_serverCommands = {
	\ 'haskell': ['hie-wrapper'],
	\ 'lua': ['lua-lsp'],
	\ 'purescript': ['purescript-language-server', '--stdio', '--config', '{}'],
	\ 'rust': ['rls']
\ }

let g:LanguageClient_useVirtualText=0

" }}}

" Missing filetypes {{{

lua plug('https://github.com/JulesWang/css.vim.git', 'filetypes/start/css', 'master')
lua plug('https://github.com/othree/html5.vim.git', 'filetypes/start/html', 'master')

lua plug('https://github.com/dag/vim-fish.git', 'filetypes/start/fish', 'master')
lua plug('https://github.com/LnL7/vim-nix', 'filetypes/start/nix', 'master')

-- Haskell
lua plug('https://github.com/pbrisbin/vim-syntax-shakespeare.git', 'haskell/start/shakespeare', 'master')
lua plug('https://github.com/zenzike/vim-haskell-unicode.git', 'haskell/start/unicode', 'master')

lua plug('https://github.com/lifepillar/pgsql.vim.git', 'filetypes/start/pgsql', 'master')
lua plug('https://github.com/raichoo/purescript-vim.git', 'filetypes/start/purescript', 'master')
lua plug('https://github.com/rust-lang/rust.vim.git', 'filetypes/start/rust', 'master')
lua plug('https://github.com/keith/swift.vim.git', 'filetypes/start/swift', 'master')

" }}}

" MUcomplete {{{

lua plug('https://github.com/lifepillar/vim-mucomplete.git', 'general/start/mucomplete', 'master')

let g:mucomplete#chains={ 'default' : [ 'omni', 'path', 'uspl' ] }

let g:mucomplete#enable_auto_at_startup=1

let g:mucomplete#minimum_prefix_length=1

let g:mucomplete#no_mappings=0

set completeopt=menuone,noinsert

" }}}

" Random Colors {{{

lua plug('git@github.com:tssm/nvim-random-colors.git', 'general/start/random-colors', 'master')

command! RandomColorScheme lua require('random-colors')()

" }}}

" Rooter {{{

lua plug('https://github.com/airblade/vim-rooter.git', 'general/start/rooter', 'master')

let g:rooter_patterns=[ '.git', '.git/', '.pijul/' ]

let g:rooter_resolve_links=1

let g:rooter_silent_chdir=1

" }}}

" Startify {{{

lua plug('https://github.com/mhinz/vim-startify.git', 'general/start/startify', 'master')

let g:startify_change_to_dir=0

let g:startify_commands=[ { 't': 'terminal' } ]

let g:startify_custom_header=''

let g:startify_lists = [
	\ { 'type': 'sessions', 'header': [ ' Sessions' ] },
	\ { 'type': 'files', 'header': [ ' Recent files' ] },
	\ { 'type': 'commands', 'header': [ ' Commands' ] }
	\ ]

let g:startify_session_persistence=1

let g:startify_update_oldfiles = 1

augroup Startify
	autocmd!
	autocmd User StartifyReady
		\ setlocal buftype=nofile |
		\ setlocal statusline=Startify |
		\ setlocal statusline=\ |
		\ LengthmattersReload
augroup END

" }}}

" Template {{{

lua plug('https://github.com/aperezdc/vim-template.git', 'general/start/template', 'master')

let g:templates_directory=[stdpath('config') . '/templates']

let g:templates_global_name_prefix='template.'

let g:templates_no_builtin_templates=1

" }}}

" Undotree {{{

lua plug('https://github.com/mbbill/undotree.git', 'general/start/undotree', 'master')

let g:undotree_HelpLine=0

let g:undotree_SetFocusWhenToggle=1

" }}}

" Vista {{{

lua plug('https://github.com/liuchengxu/vista.vim.git', 'general/start/vista', 'master')

let g:vista_default_executive="lcn"

let g:vista_sidebar_width=80

nnoremap <silent> <f6> :Vista!!<cr>

" }}}

" vim: foldenable foldmethod=marker
