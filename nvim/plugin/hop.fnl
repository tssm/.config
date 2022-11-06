(let
  [hop (require :hop)
   hop-to hop.hint_char1
   direction (. (require :hop.hint) :HintDirection)
   set-map (fn [lhs rhs] (vim.keymap.set [:n :o :x] lhs rhs))]
  (hop.setup {:uppercase_labels true})

  (set-map :f :<cmd>HopChar1AC<cr>)
  (set-map :F :<cmd>HopChar1BC<cr>)

  (set-map :t (fn [] (hop-to {:direction direction.AFTER_CURSOR :hint_offset -1})))
  (set-map :T (fn [] (hop-to {:direction direction.BEFORE_CURSOR :hint_offset 1})))

  (set-map :b :<cmd>:HopWordBC<cr>)
  (set-map :w :<cmd>:HopWordAC<cr>)

  (set-map :_ :<cmd>:HopVertical<cr>))
