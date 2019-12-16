if exists('g:fvim_loaded')
	FVimCursorSmoothBlink v:true
	FVimCursorSmoothMove v:true
	FVimCustomTitleBar v:false
	set guifont=Iosevka\ Term:h16
elseif has('gui_vimr')
	VimRHideTools
	VimRSetFontAndSize "Iosevka Term", 16
	VimRToggleFullscreen
endif
