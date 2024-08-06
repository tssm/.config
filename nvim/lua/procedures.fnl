(fn first-path-containing [markers from]
  (let [fs vim.fs]
    (fs.dirname (. (fs.find markers {:path from :upward true}) 1))))

(fn repo [from] (first-path-containing [:.git :.pijul] from))

(fn root [with of]
  (let [from (vim.fs.dirname of)]
    (or
      (first-path-containing with from)
      (repo from)
      (vim.fn.getcwd))))

{:repo repo
 :root root}
