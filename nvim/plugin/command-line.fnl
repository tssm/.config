(set vim.opt.history 100)

(let [set-map (fn [lhs rhs] (vim.keymap.set :c lhs rhs))]
  ; Make the command line behave like Fish
  (set-map :<c-a> :<home>) ; Go to line beginning
  (set-map :<c-b> :<left>) ; Go back one character
  (set-map :<c-f> :<right>) ; Go forward one character
  (set-map :∫ :<s-left>) ; Go back one word
  (set-map :ƒ :<s-right>) ; Go forward one word
  (set-map :<c-p> :<up>) ; Search prefix backwards
  (set-map :<c-n> :<down>)) ; Search prefix forward
