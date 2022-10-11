(fn create-file [path-suggestion]
	(vim.call :feedkeys (.. ":edit " path-suggestion)))

(fn first-path-containing [markers from]
	(local fs vim.fs)
	(fs.dirname (. (fs.find markers {:path from :upward true}) 1)))

(fn repo [from] (first-path-containing [:.git :.pijul] from))

(fn root [with of]
	(local from (vim.fs.dirname of))
	(or
		(first-path-containing with from)
		(repo from)
		(vim.fn.getcwd)))

{
	:create-file create-file
	:repo repo
	:root root}
