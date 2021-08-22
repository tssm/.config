(local cmd vim.cmd)
(cmd "augroup DefaultBehaviour")
(cmd "autocmd!")
(cmd "autocmd VimEnter * clearjumps")
; Neovim remote
(cmd "autocmd BufRead,BufNewFile addp-hunk-edit.diff setlocal bufhidden=wipe")
(cmd "autocmd FileType gitcommit,gitrebase setlocal bufhidden=wipe")
; Restore cursor shape on exit
(cmd "autocmd VimLeave * set guicursor=a:ver35-blinkon1")
(cmd "autocmd VimLeavePre * lua My.clean_up()")
; Resize windows proportionally
(cmd "autocmd VimResized * wincmd =")
(cmd "augroup END")

(local call vim.api)
(fn clean-up []
	(each [_ bufnr (ipairs (call.nvim_list_bufs))]
		(when (not= (call.nvim_buf_get_option bufnr :buftype) "")
			(cmd (string.format "bwipeout %i" bufnr)))))
(set My.clean_up clean-up)

(local opt vim.opt)
(set opt.clipboard [:unnamed :unnamedplus])
(opt.diffopt:append :vertical)
(set opt.hidden true)
(set opt.mouse :a)
(set opt.ruler false)
(set opt.sessionoptions [:curdir :help :tabpages :winsize])
(set opt.shada "'100,rman:,rocto:,rterm:,r/private/tmp/,r/private/var/")
(set opt.shortmess :csF)
(set opt.spelloptions :camel)
(set opt.tildeop true)
(set opt.visualbell true)
(set opt.wildignorecase true)

; Tab pages
(set opt.splitbelow true)
(set opt.splitright true)
