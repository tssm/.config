let s:config_path='~/.config/nvim'
" Common paths

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
		\ elseif &buftype ==# 'terminal' |
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

set mouse=a

set nojoinspaces
" Use only 1 space after '.' when joining lines

set noshowmode
" Because Neovim's cursor shape

augroup ResizeWindowsProportionally
	autocmd!
	autocmd VimResized * :wincmd =
augroup END

set secure exrc
" Load .nvimrc from current directory

set shortmess+=c

set visualbell
" Turns off annoying sound

" }}}

" Color schemes {{{

lua <<EOF
local pack = require('pack')
pack('https://github.com/dennougorilla/azuki.vim.git', 'colors/opt/azuki', 'master')
pack('https://github.com/thenewvu/vim-colors-blueprint.git', 'colors/opt/blueprint', 'master')
pack('git@github.com:tssm/c64-vim-color-scheme', 'colors/opt/c64', 'master')
pack('https://github.com/Jimeno0/vim-chito.git', 'colors/opt/chito', 'master')
pack('https://github.com/agreco/vim-citylights.git', 'colors/opt/citylights', 'master')
pack('https://github.com/archSeer/colibri.vim.git', 'colors/opt/colibri', 'master')
pack('git@github.com:tssm/fairyfloss.vim', 'colors/opt/fairyfloss', 'master')
pack('https://github.com/MaxSt/FlatColor.git', 'colors/opt/flat', 'master')
pack('https://github.com/charlespeters/ganymede.vim.git', 'colors/opt/ganymede', 'master')
pack('https://github.com/aereal/vim-colors-japanesque.git', 'colors/opt/japanesque', 'master')
pack('https://github.com/trevordmiller/nova-vim.git', 'colors/opt/nova', 'master')
pack('https://github.com/nightsense/snow.git', 'colors/opt/snow', 'master')
pack('https://github.com/nightsense/strawberry.git', 'colors/opt/strawberry', 'master')
pack('https://github.com/rupertqin/ThyName.git', 'colors/opt/thyname', 'master')
EOF

set background=dark

set termguicolors
" Enable true color

augroup FixColorSchemes
	autocmd!
	autocmd ColorScheme *
		\ highlight EndOfBuffer guibg=bg guifg=bg |
		\ highlight LineNr guibg=bg |
		\ highlight CursorLineNr guibg=bg guifg=bg |
		\ highlight MatchParen guibg=bg guifg=NONE gui=underline |
		\ highlight SignColumn guibg=bg |
		\ highlight SpecialKey guibg=bg |
		\ highlight TermCursorNC guibg=bg guifg=bg
augroup END

let g:ganymede_solid_background=1

" }}}

" Completion {{{

lua <<EOF
local pack = require('pack')
pack('https://github.com/roxma/nvim-yarp.git', 'completion/start/yarp', 'master')
pack('https://github.com/ncm2/ncm2.git', 'completion/start/ncm2', 'master')
pack('https://github.com/ncm2/ncm2-bufword.git', 'completion/start/bufword', 'master')
pack('https://github.com/ncm2/ncm2-cssomni.git', 'completion/start/css', 'master')
pack('https://github.com/ncm2/ncm2-html-subscope.git', 'completion/start/html-subscope', 'master')
pack('https://github.com/ncm2/ncm2-path.git', 'completion/start/path', 'master')
EOF

autocmd BufEnter * call ncm2#enable_for_buffer()
autocmd TextChangedI * call ncm2#auto_trigger()

inoremap <c-c> <ESC>
" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.

inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <TAB> to select the popup menu:

let g:ncm2#complete_length=1

set completeopt=menuone,noinsert,noselect
" noinsert is required by ncm2

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

let mapleader="\<Tab>"
" Tab is located in the center of my keyboard

noremap! <c-\> <esc>
tnoremap <c-\> <c-\><c-n>

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

call luaeval("require('pack')('https://github.com/henrik/vim-indexed-search.git', 'general/start/indexed-search', 'master')")

let g:indexed_search_center=1

" }}}

" Sessions {{{

set sessionoptions=curdir,tabpages,winsize

" }}}

" Spell {{{

augroup EnableSpellChecking
	autocmd!
	autocmd BufWinEnter *
		\ if &buftype == '' |
		\ 	set spell spelllang=en,es |
		\ else |
		\ 	set nospell |
		\ endif
	autocmd TermOpen * set nospell
augroup END

" }}}

" Statusline {{{

function! GetCursorPosition()
	let l:position = getcurpos()

	return IsSpecialBuffer() && &buftype != 'help'
		\ ? ''
		\ : '  ' . l:position[1] . '☰' . ' ' . l:position[2] . '☷' . ' '
		" The last empty space is necessary to compensate for bad Unicode font
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

augroup StartTerminalOnInsertMode
	autocmd!
	autocmd TermOpen *
		\ if match(b:term_title, 'fish') != -1 || match(b:term_title, 'ssh') != -1 |
		\   startinsert |
		\ endif
augroup END

command! -nargs=* -complete=shellcmd T vsplit | terminal <args>
" Open the terminal in a vertical split

command! -nargs=1 -complete=dir -bang S %bwipeout<bang> | cd <args> | terminal
" cd into <args> and start a terminal. S is short for shell

set scrollback=-1

" }}}

" User interface {{{

set fillchars=fold:\ ",vert:┃
" Hides the decoration of folds and sets a continuous vertical windows separator

set list listchars=extends:…,precedes:…,tab:\ \ ,trail:☠
" Display trailing spaces as ☠

set numberwidth=3

set showmatch
" Highlight matching braces when cursor is over one of them

set showtabline=0
" Never show the tabline

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

" }}}

" Packages

lua <<EOF
local pack = require('pack')
pack('https://github.com/metakirby5/codi.vim.git', 'general/start/codi', 'master')
pack('https://github.com/editorconfig/editorconfig-vim.git', 'general/start/editorconfig', 'master')
pack('https://github.com/tpope/vim-commentary.git', 'general/start/commentary', 'master')
pack('https://github.com/lifecrisis/vim-difforig.git', 'general/start/difforig', 'master')

pack('https://github.com/cohama/lexima.vim.git', 'lexima/start/lexima', 'master')
pack('https://github.com/zandrmartin/lexima-template-rules.git', 'lexima/start/template-rules', 'master')

pack('https://gist.github.com/ds26gte/034b9ac9edeaf86d0ff5c73f97dd530b', 'general/start/keep-terminal', 'master')
pack('https://github.com/tpope/vim-repeat.git', 'general/start/repeat', 'master')
pack('https://github.com/tpope/vim-sleuth.git', 'general/start/sleuth', 'master')
pack('https://github.com/chr4/sslsecure.vim', 'general/start/sslsecure', 'master')
pack('https://github.com/tpope/vim-surround.git', 'general/start/surround', 'master')
pack('git@github.com:tssm/tectonic.vim.git', 'general/start/tectonic', 'master')
pack('git@github.com:tssm/vertical-help.vim.git', 'general/start/vertical-help', 'master')
EOF

" Colorize {{{

call luaeval("require('pack')('https://github.com/chrisbra/color_highlight.git', 'general/start/colorizer', 'master')")

let g:colorizer_colornames=0

let g:colorizer_disable_bufleave=1

let g:colorizer_skip_comments=1

" }}}

" FileBeagle {{{

call luaeval("require('pack')('https://github.com/jeetsukumaran/vim-filebeagle.git', 'general/start/filebeagle', 'master')")

command! -nargs=1 -complete=dir -bang E %bwipeout<bang> | cd <args> | FileBeagle
" cd into <args> and start FileBeagle. E is short for explore

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let g:filebeagle_suppress_keymaps = 1
nmap <silent> - <Plug>FileBeagleOpenCurrentBufferDir
nmap <silent> _ <Plug>FileBeagleOpenCurrentWorkingDir

let g:filebeagle_check_gitignore = 1

" }}}

" FZY {{{

call luaeval("require('pack')('https://github.com/cloudhead/neovim-fuzzy.git', 'general/start/fuzzy', 'master')")

nnoremap <Leader>f :FuzzyOpen<cr>

" }}}

" Grepper {{{

call luaeval("require('pack')('https://github.com/mhinz/vim-grepper.git', 'general/start/grepper', 'master')")

let g:grepper = {
	\ 'rg': {
		\ 'grepprg': 'rg --no-heading --smart-case --vimgrep --with-filename'
	\ },
	\ 'highlight': 1,
	\ 'simple_prompt': 1
\ }

nnoremap <Leader>g :Grepper -tool rg<cr>
nnoremap <F5> :Grepper -tool rg -query '\bBUG\b\|\bFIXME\b\|\bHACK\b\|\bTODO\b\|\bUNDONE\b\|\bXXX\b'<cr>

nmap <Leader>* <plug>(GrepperOperator)
xmap <Leader>* <plug>(GrepperOperator)

function! s:handleGrepperResults()
	if len(getqflist()) == 1
		cfirst
		cclose
	endif
endfunction

augroup Grepper
	autocmd!
	autocmd User Grepper |
		\ call s:handleGrepperResults() |
		\ setlocal statusline=%{w:quickfix_title}
augroup END

" }}}

" {{{ Language Client

call luaeval("require('pack')('https://github.com/autozimu/LanguageClient-neovim.git', 'general/start/languageclient', 'next', 'bash install.sh')")

autocmd User LanguageClientStarted |
	\ set signcolumn=yes |
	\ nnoremap <silent> <c-]> :call LanguageClient#textDocument_definition()<cr> |
	\ nnoremap <silent> K :call LanguageClient#textDocument_hover()<cr> |
	\ nnoremap <silent> <f6> :call LanguageClient_textDocument_documentSymbol()<cr>
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

let g:LanguageClient_rootMarkers = {
	\ 'haskell': ['*.cabal'],
	\ 'lua': ['.luacompleterc'],
	\ 'purescript': ['psc-package.json'],
	\ 'rust': ['Cargo.toml'],
	\ }

let g:LanguageClient_serverCommands = {
	\ 'haskell': ['hie-wrapper'],
	\ 'lua': ['lua-lsp'],
	\ 'purescript': ['purescript-language-server', '--stdio', '--config', '{}'],
	\ 'rust': ['rls']
\ }

" }}}

" Lengthmatters {{{

call luaeval("require('pack')('https://github.com/whatyouhide/vim-lengthmatters.git', 'general/start/lengthmatters', 'master')")

autocmd FixColorSchemes ColorScheme * highlight OverLength guibg=fg guifg=bg

" }}}

" Missing filetypes {{{

lua <<EOF
local pack = require('pack')
pack('https://github.com/JulesWang/css.vim.git', 'filetypes/start/css', 'master')
pack('https://github.com/othree/html5.vim.git', 'filetypes/start/html', 'master')

pack('https://github.com/dag/vim-fish.git', 'filetypes/start/fish', 'master')
pack('https://github.com/LnL7/vim-nix', 'filetypes/start/nix', 'master')

-- Haskell
pack('https://github.com/pbrisbin/vim-syntax-shakespeare.git', 'haskell/start/shakespeare', 'master')
pack('https://github.com/zenzike/vim-haskell-unicode.git', 'haskell/start/unicode', 'master')

pack('https://github.com/lifepillar/pgsql.vim.git', 'filetypes/start/pgsql', 'master')
pack('https://github.com/raichoo/purescript-vim.git', 'filetypes/start/purescript', 'master')
pack('https://github.com/rust-lang/rust.vim.git', 'filetypes/start/rust', 'master')
pack('https://github.com/keith/swift.vim.git', 'filetypes/start/swift', 'master')
EOF

" }}}

" Mundo {{{

call luaeval("require('pack')('https://github.com/simnalamburt/vim-mundo.git', 'general/start/mundo', 'master')")

let g:mundo_preview_bottom=1

let g:mundo_preview_statusline="Mundo Preview"

let g:mundo_right=1

let g:mundo_tree_statusline="Mundo Tree"

" }}}

" Random Colors {{{

call luaeval("require('pack')('git@github.com:tssm/nvim-random-colors.git', 'general/start/random-colors', 'master')")

command! RandomColorScheme call luaeval("require('random-colors')()")

" }}}

" Rooter {{{

call luaeval("require('pack')('https://github.com/airblade/vim-rooter.git', 'general/start/rooter', 'master')")

let g:rooter_patterns=[ '.git', '.git/', '.pijul/' ]

let g:rooter_resolve_links=1

let g:rooter_silent_chdir=1

" }}}

" Startify {{{

call luaeval("require('pack')('https://github.com/mhinz/vim-startify.git', 'general/start/startify', 'master')")

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

autocmd User StartifyReady setlocal statusline=Startify

" }}}

" Template {{{

call luaeval("require('pack')('https://github.com/aperezdc/vim-template.git', 'general/start/template', 'master')")

let g:templates_directory=[s:config_path . '/templates']

let g:templates_global_name_prefix='template.'

let g:templates_no_builtin_templates=1

" }}}

" vim: foldenable foldmethod=marker
