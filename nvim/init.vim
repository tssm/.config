scriptencoding utf-8
" Declares the encoding of this script

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
Plug 'https://github.com/chriskempson/base16-vim.git'
Plug 'https://github.com/zenorocha/dracula-theme.git', {'rtp': 'vim'}
Plug 'https://github.com/cocopon/iceberg.vim'
Plug 'https://github.com/nanotech/jellybeans.vim.git'
Plug 'https://github.com/justinmk/molokai.git'
Plug 'https://github.com/AlessandroYorba/Sierra.git'
Plug 'https://github.com/freeo/vim-kalisi.git'
Plug 'https://github.com/Sclarki/neonwave.vim.git'
Plug 'https://github.com/abra/vim-obsidian.git'

" CSS plug-ins
Plug 'https://github.com/jaxbot/browserlink.vim.git', {'for': 'css'}
Plug 'https://github.com/JulesWang/css.vim.git', {'for': 'css'}
" HTML plug-ins
Plug 'https://github.com/othree/html5.vim.git', {'for': 'html'}
" JavaScript plug-ins
Plug 'https://github.com/gavocanov/vim-js-indent', {'for': 'javascript'}
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
Plug 'https://github.com/tpope/vim-endwise.git'
Plug 'https://github.com/chrisbra/color_highlight.git', {'on': 'ColorToggle'}
Plug 'https://github.com/xolox/vim-misc.git' | Plug 'https://github.com/xolox/vim-colorscheme-switcher.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/Konfekt/FastFold.git' | Plug 'https://github.com/Shougo/deoplete.nvim.git'
Plug 'https://github.com/mhinz/vim-grepper.git'
Plug 'https://github.com/sjl/gundo.vim.git', {'on': 'GundoToggle'}
Plug 'https://github.com/takac/vim-hardtime.git'
Plug 'https://github.com/torbiak/probe.git'
Plug 'https://github.com/kana/vim-smartinput.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/aperezdc/vim-template.git'
Plug 'https://github.com/wakatime/vim-wakatime'

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

set complete=t,i,kspell,.,w,b

set completeopt=menu

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

syntax on

" augroup SetCursorLine
" 	au!
" 	au VimEnter * setlocal cursorline
" 	au WinEnter * setlocal cursorline
" 	au BufWinEnter * setlocal cursorline
" 	au WinLeave * setlocal nocursorline
" augroup END
" Highlights the cursor line only on the focused window

set fillchars+=vert:\ 
" Hides the decoration of the vertical separator of splited windows

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

nnoremap Y y$
" Makes Y behaves like C and D.

nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" Replace the word under cursor.

" }}}

" Indentation {{{

set smartindent
" Do smart autoindenting when starting a new line

set tabstop=2
" Number of spaces that a <Tab> in the file counts for

set shiftwidth=2
" Number of spaces to use for each step of indent

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

set sessionoptions=curdir,tabpages,winsize

" }}}

" Tab pages {{{

set splitbelow
" Creates new horizontal windows at the bottom

set splitright
" Creates new vertical windows at the right

" }}}

" User interface {{{

set relativenumber
" Displays how far away each line is from the current one

set showcmd
" Always show the command line

set showmatch
" Highlight matching braces when cursor is over one of them

set showtabline=0
" Never show the tabline

function! GetFilename()
	return
		\ &filetype == 'gundo' ? 'Gundo Tree' :
		\ &filetype == 'help' ? 'Neovim Help: ' . expand('%:t:r') :
		\ &filetype == 'qf' ? 'Quickfix List' :
		\ &filetype == 'vim-plug' ? 'Plug' :
		\ expand('%:t') == '__Gundo_Preview__' ? 'Gundo Preview' :
		\ expand('%:p')
endfunction

function! GetWarnings()
	return
		\ (&fileformat == 'unix' ?
			\ '' :
			\ ' ' . &fileformat) .
		\ (strlen(&fileencoding) ?
			\ (&fileencoding == 'utf-8' ?
				\ '' :
				\ ' ' . &fileencoding) :
			\ (&encoding == 'utf-8' ?
				\ '' :
				\ ' ' . &encoding)
		\ ) .
		\ (&modified ? ' 💾 ' : '') .
		\ ((&filetype == 'gundo' ||
			\ &filetype == 'help' ||
			\ &filetype == 'qf' ||
			\ &filetype == 'vim-plug' ||
			\ expand('%:t') == '__Gundo_Preview__') ||
			\ !&readonly ? '' : ' 🔒 ')
endfunction

autocmd Filetype qf setlocal statusline=

set statusline=%{GetFilename()}%=%{GetWarnings()}

" }}}

" Wildmenu {{{

set wildignore=.git, " Git stuff
set wildignore+=.DS_Store, " OS crap
set wildignore+=build/**,*.a,*.class,*.marko.js,*.mo,*.o,*.pyc, " Compiled stuff
set wildignore+=*.gif,*.jpeg,*.jpg,*.pdf,*.png,*.xib, " Graphic stuff
set wildignore+=.nvimrc,Session.vim, " Neovim stuff
set wildignore+=node_modules/**,.tern-project, " JavaScript stuff
set wildignore+=*.log
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

" set list listchars=extends:…,precedes:…,tab:\ \ ,trail:😠
" Display trailing spaces as 😠

" }}}

" Scripts

" Choosewin {{{

let g:choosewin_blink_on_land=0

let g:choosewin_overlay_enable=1

let g:choosewin_statusline_replace=0

nmap <C-w>w <Plug>(choosewin)

" }}}

" Color scheme switcher {{{

let g:colorscheme_switcher_exclude=[
	\ 'base16-3024',
	\ 'base16-atelierheath',
	\ 'base16-brewer',
	\ 'base16-bright',
	\ 'base16-codeschool',
	\ 'base16-colors',
	\ 'base16-embers',
	\ 'base16-grayscale',
	\ 'base16-greenscreen',
	\ 'base16-isotope',
	\ 'base16-londontube',
	\ 'base16-marrakesh',
	\ 'base16-pop',
	\ 'base16-shapeshifter'
	\ ]

let g:colorscheme_switcher_exclude_builtins=1

let g:colorscheme_switcher_keep_background=1

augroup RandomColorScheme
	autocmd!
	autocmd VimEnter * :RandomColorScheme
augroup END

" }}}

" Deoplete {{{

let g:deoplete#enable_at_startup=1

let g:deoplete#auto_completion_start_length=1

let g:deoplete#sources={}
let g:deoplete#sources._=['omni', 'member', 'buffer', 'dictionary']

" }}}

" Grepper {{{

nnoremap <Leader>g :Grepper -tool ag -nojump -noopen<cr>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

function! s:handleGrepperResults()
	let l:quickfixLength = len(getqflist())

	if l:quickfixLength == 1
		cfirst
	elseif l:quickfixLength > 1
		botright cwindow
	endif
endfunction

augroup Grepper
	autocmd!
	autocmd User Grepper call s:handleGrepperResults()
augroup END

" }}}

" Gundo {{{

let g:gundo_help=0
" Hiddes help

" }}}

" Hardtime {{{

let g:hardtime_allow_different_key=1
" Makes it is possible to input 'jh', but not 'jj'

let g:hardtime_default_on=1

let g:list_of_normal_keys=['h', 'j', 'k', 'l', 'x', '-', '+', '<Up>', '<Down>', '<Left>', '<Right>', '<Space>', '<Enter>', '<BS>']

let g:list_of_visual_keys=g:list_of_normal_keys

" }}}

" Netrw {{{

let g:netrw_altv=0
" Creates new vertical windows at the right

let g:netrw_banner=0
" Supress the help banner

let g:netrw_home=expand(s:cache_path)
" Place to store .netrwhist & .netrwbook

let g:netrw_list_hide='"' . &wildignore . '"'
" Ignore the same that wildignore

let g:netrw_liststyle=0
" Displays one file per line

let g:netrw_sort_options='i'
" Ignores case when sorting files

let g:netrw_preview=1
" Creates vertical preview windows

let g:netrw_winsize=80
" Specify initial size of new windows

" }}}

" Probe {{{

let g:probe_cache_dir=s:cache_path . '/probe'

let g:probe_use_wildignore=1

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
:command! D call <SID>DiffTab()
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
