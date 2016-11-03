let s:cache_path='~/.cache/nvim'
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
Plug 'https://github.com/MvanDiemen/ghostbuster.git'
Plug 'https://github.com/scwood/vim-hybrid.git'
Plug 'https://github.com/aereal/vim-colors-japanesque.git'
Plug 'https://github.com/raphamorim/lucario.git'
Plug 'https://github.com/cseelus/vim-colors-lucid.git'
Plug 'https://github.com/trevordmiller/nova-vim.git'
Plug 'https://github.com/rakr/vim-one.git'
Plug 'https://github.com/geoffharcourt/one-dark.vim.git'
Plug 'https://github.com/yous/vim-open-color.git'
Plug 'https://github.com/reedes/vim-colors-pencil.git'
Plug 'https://github.com/juanedi/predawn.vim.git'
Plug 'https://github.com/colepeters/spacemacs-theme.vim.git'
Plug 'https://github.com/rakr/vim-two-firewatch.git'
Plug 'https://github.com/bcicen/vim-vice.git'
Plug 'https://github.com/lifepillar/vim-wwdc16-theme.git'

" CSS plug-ins
Plug 'https://github.com/JulesWang/css.vim.git', {'for': 'css'}
" HTML plug-ins
Plug 'https://github.com/othree/html5.vim.git', {'for': 'html'}
" JavaScript plug-ins
Plug 'https://github.com/gavocanov/vim-js-indent', {'for': 'javascript'}
Plug 'carlitux/deoplete-ternjs', {'do': 'npm install -g tern', 'for': 'javascript'}
Plug 'https://github.com/marijnh/tern_for_vim.git', {'do': 'npm install', 'for': 'javascript'}
Plug 'https://github.com/othree/yajs.vim.git', {'for': 'javascript'}
" Rust plug-ins
if (executable("cargo"))
	Plug 'https://github.com/phildawes/racer.git', {'for': 'rust', 'do': 'cargo build --release'}
	Plug 'https://github.com/rust-lang/rust.vim.git', {'for': 'rust'}
endif
" Swift plug-ins
Plug 'https://github.com/landaire/deoplete-swift.git', {'for': 'swift'}
Plug 'https://github.com/keith/swift.vim.git', {'for': 'swift'}

" General plug-ins
Plug 'https://github.com/t9md/vim-choosewin.git'
Plug 'https://github.com/editorconfig/editorconfig-vim.git'
Plug 'https://github.com/cloudhead/neovim-fuzzy.git'
Plug 'https://github.com/chrisbra/color_highlight.git', {'on': 'ColorToggle'}
Plug 'https://github.com/xolox/vim-misc.git' | Plug 'https://github.com/xolox/vim-colorscheme-switcher.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/Konfekt/FastFold.git' | Plug 'https://github.com/Shougo/deoplete.nvim.git'
Plug 'https://github.com/mhinz/vim-grepper.git'
Plug 'https://github.com/takac/vim-hardtime.git'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'https://github.com/cohama/lexima.vim.git'
Plug 'https://github.com/zandrmartin/lexima-template-rules.git'
Plug 'https://github.com/simnalamburt/vim-mundo.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/aperezdc/vim-template.git'

Plug '~/Documents/sessionmatic.vim'
Plug '~/Documents/vertical-help.vim'
Plug '~/Documents/toggle-spell-lang.vim/'

call plug#end()

" }}}

" Behavior {{{

augroup AutoLoadVimrcChanges
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

set clipboard=unnamed,unnamedplus
" Uses the clipboard as the unnamed register

set completeopt=menuone,noinsert

set hidden
" Allows hidden buffers without writing them

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
		\ highlight SpecialKey guibg=bg
augroup END

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
		\ &filetype == 'help' ? expand('%:t:r') . ' help ' :
		\ &filetype == 'qf' ? 'Quickfix list ' :
		\ &filetype == 'vim-plug' ? 'Plug ' :
		\ strlen(expand('%')) > 0 ? expand('%') : '🆕'
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
		\ &filetype == 'mundo' ||
		\ &filetype == 'help' ||
		\ &filetype == 'qf' ||
		\ &filetype == 'vim-plug' ||
		\ expand('%:t') == '__Mundo_Preview__'
endfunction

autocmd Filetype qf setlocal statusline=

set statusline=
set statusline+=%{GetCurrentDir()}
set statusline+=%{GetFilename()}\ 
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

" User interface {{{

set fillchars=fold:\ ,vert:┃
" Hides the decoration of folds and sets a continuous vertical windows separator

set list listchars=extends:…,precedes:…,tab:\ \ ,trail:☠
" Display trailing spaces as ☠

set numberwidth=3

set relativenumber
" Displays how far away each line is from the current one

set showcmd
" Always show the command line

set showmatch
" Highlight matching braces when cursor is over one of them

set showtabline=0
" Never show the tabline

" }}}

" Wildmenu {{{

set wildignore+=.DS_Store,*.log,.nvimrc,Session.vim,.tern-project
" Should be read from global .gitignore
set wildignore+=build/**,node_modules/**,tmp/**
" Should be read from project .gitignore
set wildignore+=*.a,*.class,*.gem,*.lock,*.marko.js,*.mo,*.o,*.pyc,.vagrant
" Should be read from project .gitignore
set wildignore+=*.gif,*.jpeg,*.jpg,*.pdf,*.png,*.svg,*.xib
" Graphic stuff
set wildignore+=.git
set wildignore+=.keep
" Files ignored by the wildmenu

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

" Choosewin {{{

let g:choosewin_blink_on_land=0

let g:choosewin_overlay_enable=1

let g:choosewin_statusline_replace=0

nmap <C-w>w <Plug>(choosewin)

" }}}

" Color scheme switcher {{{

let g:colorscheme_switcher_exclude_builtins=1

let g:colorscheme_switcher_keep_background=1

augroup RandomColorScheme
	autocmd!
	autocmd VimEnter * RandomColorScheme
augroup END

" }}}

" Deoplete {{{

let g:deoplete#auto_complete_start_length=1

let g:deoplete#enable_at_startup=1

let g:deoplete#file#enable_buffer_path=1

let g:deoplete#sources={
	\ '_': ['tag', 'omni', 'file'],
	\ 'javascript': ['ternjs'],
	\ 'markdown': ['dictionary']
	\ }

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

nnoremap <Leader>g :Grepper -tool ag -nojump<cr>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

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

" Hardtime {{{

let g:hardtime_allow_different_key=1
" Makes it is possible to input 'jh', but not 'jj'

let g:hardtime_default_on=1

let g:list_of_normal_keys=['h', 'j', 'k', 'l', 'x', '+', '<Up>', '<Down>', '<Left>', '<Right>', '<Space>', '<Enter>', '<BS>']

let g:list_of_visual_keys=g:list_of_normal_keys

" }}}

" Mundo {{{

let g:mundo_help=0
" Hiddes help

let g:mundo_preview_statusline="Mundo Preview"

let g:mundo_tree_statusline="Mundo Tree"

" }}}

" Racer {{{

let g:racer_cmd = s:data_path . '/racer/target/release/racer'

" }}}

" Swift {{{

let g:deoplete#sources#swift#daemon_autostart = 1

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

" {{{ Useful stuff that could be different plug-ins

let s:diff_tab=0
function! s:DiffTab()
	if s:diff_tab > 0
		windo diffoff
		windo set noscrollbind
		let s:diff_tab=0
	else
		windo diffthis
		windo set scrollbind
		let s:diff_tab=1
	endif
endfunction
command! D call <SID>DiffTab()
" Toggle diff of current tab

augroup DirectoryExists
	autocmd!
	autocmd BufNewFile * call s:DirectoryExists()
augroup END

function! s:DirectoryExists()
	let required_dir = expand("%:h")

	if !isdirectory(required_dir)
		if !confirm("Directory '" . required_dir . "' doesn't exist. Create it?")
			return
		endif

		try
			call mkdir(required_dir, 'p')
		catch
			echoerr "Can't create '" . required_dir . "'"
		endtry
	endif
endfunction

" }}}
