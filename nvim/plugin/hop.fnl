(local hop (require :hop))
(hop.setup {:uppercase_labels true})

(fn set-map [lhs rhs]
  (vim.keymap.set [:n :o :x] lhs rhs))
(set-map :f :<cmd>HopChar1AC<cr>)
(set-map :F :<cmd>HopChar1BC<cr>)

(local hop-to hop.hint_char1)
(local direction (. (require :hop.hint) :HintDirection))
(fn forward-until   [] (hop-to {:direction direction.AFTER_CURSOR :hint_offset -1}))
(fn backwards-until [] (hop-to {:direction direction.BEFORE_CURSOR :hint_offset 1}))
(set-map :t forward-until)
(set-map :T backwards-until)

(set-map :b :<cmd>:HopWordBC<cr>)
(set-map :w :<cmd>:HopWordAC<cr>)

(set-map :_ :<cmd>:HopVertical<cr>)
