setlocal suffixesadd=.js

autocmd BufReadPost,BufWritePost <buffer> Accio eslint

nnoremap <buffer> <C-]> :TernDef<cr>
" Use Tern to go to definition instead of :tags

nnoremap <buffer> K :TernDoc<cr>
" K shows the docummentation for whatever is under the cursor
