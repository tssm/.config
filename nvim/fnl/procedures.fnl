(fn create-file [path-suggestion]
	(vim.call :feedkeys (.. ":edit " path-suggestion)))

{:create-file create-file}
