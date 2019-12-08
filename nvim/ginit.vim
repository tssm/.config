if exists('g:fvim_loaded')
	FVimCursorSmoothBlink v:true
	FVimCursorSmoothMove v:true
	FVimCustomTitleBar v:false
	set guifont=Iosevka:h16
elseif has('gui_vimr')
	VimRHideTools
	VimRSetFontAndSize "Iosevka", 16
	VimRToggleFullscreen
endif
