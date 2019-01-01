if exists("did_load_filetypes")
	finish
endif

augroup ftdetect
	autocmd! BufRead,BufNewFile *.org setfiletype org
	autocmd! BufRead,BufNewFile Vagrantfile setfiletype ruby
augroup END
