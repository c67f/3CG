DeckClass = {}
function DeckClass:new()
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)
  
  deck.cards = {}
  
  
  return deck
end

--function DeckClass:push()
  --self.cards
--end
