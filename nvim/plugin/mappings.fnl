(fn set-map [mode lhs rhs]
  (vim.keymap.set mode lhs rhs))

(set-map "" :d "\"_d")
(set-map "" :dd "\"_dd")
(set-map "" :D "\"_D")
(set-map "" :x "\"_x")
(set-map "" :X "\"_X")

(set-map "" :c "\"_c")
(set-map "" :cc "\"_cc")
(set-map "" :C "\"_C")

(set-map "" :yd :d)
(set-map "" :yD :D)
(set-map "" :ydd :dd)

(set-map :x :p "\"_dP")

(set-map :n :gf :gF)

(set-map :n :za :zA)
(set-map :n :zm :zM)
(set-map :n :zr :zR)

(set-map :n :gd :<cmd>Bdelete!<cr>)

(set-map :n :sq :<cmd>exit<cr>)

(set-map :n :! ":te ")
(set-map :n :<C-Z> :<cmd>terminal<cr>)

(local call vim.fn)

(fn current-dir []
  (string.gsub (call.getcwd) (os.getenv :HOME) "~"))

(fn git-ref []
  (let
    [branch "git symbolic-ref --short HEAD 2> /dev/null | tr -d \"\\n\""
     commit "git rev-parse --short HEAD 2> /dev/null | tr -d \"\\n\""]
    (local ref (call.system (string.format "%s || %s" branch commit)))
    (if (= ref "") "" (string.format "   ⌥ %s" ref))))

(fn c-g []
  (vim.api.nvim_command
    (string.format "echo '%s' '%s'" (current-dir) (git-ref))))

(set-map :n :<c-g> c-g)
