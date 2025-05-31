DiscardPileClass = {}
function DiscardPileClass:new()
  local discardPile = {}
  local metadata = {__index = DiscardPileClass}
  setmetatable(discardPile, metadata)
  
  discardPile.cards = {}
  
  return discardPile
end
