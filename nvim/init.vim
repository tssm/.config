let s:config_path='~/.config/nvim'
let s:data_path='~/.local/share/nvim/site'
" Common paths

" Plug-ins definition and loading {{{

if empty(glob(s:data_path . '/autoload/plug.vim'))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
	silent execute UpdateRemotePlugins
endif
" Install Plug automatically

call plug#begin(s:data_path)

" Color schemes
Plug 'https://github.com/sonjapeterson/1989.vim.git'
Plug 'https://github.com/carriercomm/cobalt2.vim.git'
Plug 'https://github.com/tyrannicaltoucan/vim-deep-space.git'
Plug 'https://github.com/dracula/vim.git'
Plug '~/Documents/fairyfloss.vim'
Plug 'https://github.com/MaxSt/FlatColor.git'
Plug 'https://github.com/romainl/flattened.git'
Plug 'https://github.com/charlespeters/ganymede.vim.git'
Plug 'https://github.com/MvanDiemen/ghostbuster.git'
Plug 'https://github.com/scwood/vim-hybrid.git'
Plug 'https://github.com/aereal/vim-colors-japanesque.git'
Plug 'https://github.com/raphamorim/lucario.git'
Plug 'https://github.com/cseelus/vim-colors-lucid.git'
Plug 'https://github.com/KeitaNakamura/neodark.vim.git'
Plug 'https://github.com/trevordmiller/nova-vim.git'
Plug 'https://github.com/rakr/vim-one.git'
Plug 'https://github.com/mhartington/oceanic-next.git'
Plug 'https://github.com/yous/vim-open-color.git'
Plug 'https://github.com/reedes/vim-colors-pencil.git'
Plug 'https://github.com/juanedi/predawn.vim.git'
Plug 'https://github.com/colepeters/spacemacs-theme.vim.git'
Plug 'https://github.com/rakr/vim-two-firewatch.git'
Plug 'https://github.com/bcicen/vim-vice.git'
Plug 'https://github.com/lifepillar/vim-wwdc16-theme.git'
Plug 'https://github.com/tyrannicaltoucan/vim-quantum.git'
Plug 'https://github.com/rhysd/vim-color-spring-night.git'
Plug 'https://github.com/rupertqin/ThyName.git'

" CSS plug-ins
Plug 'https://github.com/JulesWang/css.vim.git', {'for': 'css'}
" Haskell
Plug 'https://github.com/zenzike/vim-haskell-unicode.git'
" HTML plug-ins
Plug 'https://github.com/othree/html5.vim.git', {'for': 'html'}
" JavaScript plug-ins
Plug 'https://github.com/gavocanov/vim-js-indent', {'for': 'javascript'}
Plug 'https://github.com/othree/yajs.vim.git', {'for': 'javascript'}
" Marko
Plug 'https://github.com/Epitrochoid/marko-vim-syntax.git'
" Rust plug-ins
Plug 'https://github.com/rust-lang/rust.vim.git', {'for': 'rust'}
" Shakespeare
Plug 'https://github.com/pbrisbin/vim-syntax-shakespeare.git'
" Swift plug-ins
Plug 'https://github.com/keith/swift.vim.git', {'for': 'swift'}
" TLS
Plug 'chr4/sslsecure.vim'

" General plug-ins
Plug 'metakirby5/codi.vim'
Plug 'https://github.com/editorconfig/editorconfig-vim.git'
Plug 'https://github.com/cloudhead/neovim-fuzzy.git'
Plug 'https://github.com/chrisbra/color_highlight.git', {'on': 'ColorToggle'}
Plug 'https://github.com/xolox/vim-misc.git' | Plug 'https://github.com/xolox/vim-colorscheme-switcher.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/mhinz/vim-grepper.git'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'https://github.com/autozimu/LanguageClient-neovim.git', {'branch': 'next', 'do': 'bash install.sh'}

Plug 'https://github.com/cohama/lexima.vim.git'
Plug 'https://github.com/zandrmartin/lexima-template-rules.git'

Plug 'https://github.com/simnalamburt/vim-mundo.git'
Plug 'https://github.com/chrisbra/Recover.vim.git'

Plug 'https://github.com/roxma/nvim-yarp.git'
Plug 'https://github.com/ncm2/ncm2.git'
Plug 'https://github.com/ncm2/ncm2-bufword.git'
Plug 'https://github.com/ncm2/ncm2-cssomni.git'
Plug 'https://github.com/ncm2/ncm2-html-subscope.git'
Plug 'https://github.com/ncm2/ncm2-path.git'

Plug 'https://github.com/tpope/vim-repeat.git'
Plug '~/Documents/sessionmatic.vim' " https://github.com/tssm/sessionmatic.vim
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/majutsushi/tagbar.git', {'on': 'TagbarToggle'}
Plug '~/Documents/tagsmatic.vim/' " https://github.com/tssm/tagsmatic.vim
Plug '~/Documents/tectonic.vim' " https://github.com/tssm/tectonic.vim
Plug '~/Documents/toggle-spell-lang.vim/' " https://github.com/tssm/toggle-spell-lang.vim
Plug 'https://github.com/aperezdc/vim-template.git'
Plug '~/Documents/vertical-help.vim' " https://github.com/tssm/vertical-help.vim

call plug#end()

" }}}

" Custom commands {{{

command T vsplit | terminal
" Open the terminal in a vertical split

" }}}

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
	autocmd VimEnter,WinEnter * set number relativenumber
	" Displays how far away each line is from the current one
	autocmd WinLeave * set number norelativenumber
augroup END

set clipboard=unnamed,unnamedplus
" Uses the clipboard as the unnamed register

" set completeopt=menuone,noinsert

set hidden
" Allows hidden buffers without writing them

set inccommand=split

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

set shada=
" Disable shada file

set shortmess+=c

set visualbell
" Turns off annoying sound

" }}}

" Color schemes {{{

set background=dark

" augroup SetCursorLine
" 	au!
" 	au VimEnter * setlocal cursorline
" 	au WinEnter * setlocal cursorline
" 	au BufWinEnter * setlocal cursorline
" 	au WinLeave * setlocal nocursorline
" augroup END
" Highlights the cursor line only on the focused window

set termguicolors
" Enable true color

augroup FixColorSchemes
	autocmd!
	autocmd ColorScheme *
		\ highlight EndOfBuffer guibg=bg guifg=bg |
		\ highlight LineNr guibg=bg |
		\ highlight CursorLineNr guibg=bg |
		\ highlight MatchParen guibg=bg guifg=NONE gui=underline |
		\ highlight SignColumn guibg=bg |
		\ highlight SpecialKey guibg=bg
augroup END

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

let mapleader="\<Tab>"
" Tab is located in the center of my keyboard

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

nnoremap n nzz
nnoremap N Nzz
vnoremap n nzz
vnoremap N Nzz

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

set sessionoptions=curdir,tabpages,winsize

" }}}

" Statusline {{{

function! GetCurrentDir()
	return IsSpecialBuffer() || (stridx(expand('%:p:h'), getcwd()) == -1)
		\ ? ''
		\ : getcwd() == $HOME ? '~/' : split(getcwd(), '/')[-1] . '/'
endfunction

function! GetCursorPosition()
	let l:position = getcurpos()

	return IsSpecialBuffer()
		\ ? ''
		\ : '☰' . l:position[1] . ' ' . '☷' . l:position[2]
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
	return
		\ &filetype == 'help' ? expand('%:t:r') . ' help' :
		\ &filetype == 'vim-plug' ? 'Plug' :
		\ &filetype == 'qf' ? 'Quickfix list' :
		\ strlen(expand('%')) > 0
			\ ? expand('%')
			\ : '🆕'
endfunction

function! GetIndentation()
	return IsSpecialBuffer()
		\ ? ''
		\ : (&expandtab ? 'spaces' : 'tabs') . '(' . &tabstop . ')'
endfunction

function! GetWarnings()
	return
		\ (&fileformat == 'unix'
			\ ? ''
			\ : ' ' . &fileformat) .
		\ (strlen(&fileencoding)
			\ ? (&fileencoding == 'utf-8'
				\ ? ''
				\ : ' ' . &fileencoding)
			\ : (&encoding == 'utf-8'
				\ ? ''
				\ : ' ' . &encoding)
		\ )
endfunction

function! IsSpecialBuffer()
	return
		\ &buftype ==# 'terminal' ||
		\ &filetype == 'help' ||
		\ &filetype == 'mundo' ||
		\ &filetype == 'vim-plug' ||
		\ &filetype == 'qf' ||
		\ expand('%:t') == '__Mundo_Preview__'
endfunction

function! GetWindowNumber()
	return winnr('$') == 1 ? '' : '(' . winnr() . ')'
endfunction

autocmd Filetype qf setlocal statusline=

set statusline=
set statusline+=%{GetCurrentDir()}
set statusline+=%{GetFilename()}
set statusline+=%{GetWindowNumber()}
set statusline+=%{GetFileStatus()}
set statusline+=%=
set statusline+=%{GetWarnings()}\ 
set statusline+=%{GetIndentation()}\ 
set statusline+=%{GetCursorPosition()}

" }}}

" Tab pages {{{

set splitbelow
" Creates new horizontal windows at the bottom

set splitright
" Creates new vertical windows at the right

" }}}

" Terminal {{{

set scrollback=-1

" }}}

" User interface {{{

set fillchars=fold:\ ,vert:┃
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

set wildignore+=.DS_Store,*.log,.nvimrc,.tern-project,Session.vim
" Should be read from global .gitignore
set wildignore+=.vagrant/**,build/**,node_modules/**,tmp/**
" Should be read from project .gitignore
set wildignore+=*.a,*.class,*.gem,*.lock,*.marko.js,*.mo,*.o,*.pyc
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

" Scripts

" Color scheme switcher {{{

let g:colorscheme_switcher_define_mappings=0

let g:colorscheme_switcher_exclude_builtins=1

let g:colorscheme_switcher_keep_background=1

augroup RandomColorScheme
	autocmd!
	autocmd VimEnter * RandomColorScheme
augroup END

" }}}

" Completion Manager {{{

let g:cm_refresh_default_min_word_len=1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use tab to select the popup menu

" }}}

" FileBeagle {{{

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let g:filebeagle_suppress_keymaps = 1
nmap <silent> - <Plug>FileBeagleOpenCurrentBufferDir
nmap <silent> _ <Plug>FileBeagleOpenCurrentWorkingDir

let g:filebeagle_check_gitignore = 1

" }}}

" FZY {{{

nnoremap <Leader>f :FuzzyOpen<cr>

" }}}

" Grepper {{{

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
	autocmd User Grepper call s:handleGrepperResults()
augroup END

" }}}

" {{{ Language Client

let g:LanguageClient_autoStart = 1

let g:LanguageClient_diagnosticsDisplay = {
	\ 1: {
		\ "name": "Error",
		\ "texthl": "SyntasticError",
		\ "signText": "⛔",
		\ "signTexthl": "Error"
	\ },
	\ 2: {
		\ "name": "Warning",
		\ "texthl": "SyntasticWarning",
		\ "signText": "⚠️",
		\ "signTexthl": "SignWarning"
	\ },
	\ 3: {
		\ "name": "Information",
		\ "texthl": "LanguageClientInformation",
		\ "signText": "ℹ️",
		\ "signTexthl": "SignInformation"
	\ },
	\ 4: {
		\ "name": "Hint",
		\ "texthl": "LanguageClientHint",
		\ "signText": "💡",
		\ "signTexthl": "SignHint"
	\ }
\ }

let g:LanguageClient_rootMarkers = {
	\ 'haskell': ['*.cabal'],
	\ 'javascript': ['project.json'],
	\ 'rust': ['Cargo.toml'],
	\ }

let g:LanguageClient_serverCommands = {
	\ 'haskell': ['hie', '--lsp'],
	\ 'javascript': ['flow-language-server', '--stdio'],
	\ 'rust': ['rls']
\ }

" }}}

" Mundo {{{

let g:mundo_help=0
" Hiddes help

let g:mundo_preview_statusline="Mundo Preview"

let g:mundo_tree_statusline="Mundo Tree"

" }}}

" NCM2 {{{

autocmd BufEnter * call ncm2#enable_for_buffer()

autocmd TextChangedI * call ncm2#auto_trigger()

let g:ncm2#complete_length=1

inoremap <c-c> <ESC>
" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.

inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <TAB> to select the popup menu:

" }}}

" Racer {{{

let g:racer_cmd = '~/.cargo/bin/racer'

let g:racer_experimental_completer = 1

" }}}

" Tagbar {{{

let g:tagbar_autofocus = 1

let g:tagbar_compact = 1

let g:tagbar_zoomwidth = 0

nmap <F6> :TagbarToggle<CR>

" }}}

" Template {{{

let g:templates_directory=[s:config_path . '/templates']

let g:templates_global_name_prefix='template.'

let g:templates_no_builtin_templates=1

" }}}

" ToggleSpellLang {{{

let g:toggle_spell_lang_alternate_languages=['es']

let g:toggle_spell_lang_mapping='<F7>'

" }}}

" vim: foldenable foldmethod=marker
