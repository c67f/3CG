DeckClass = {}
function DeckClass:new(x, y)
  local deckClass = {}
  local metadata = {__index = DeckClass}
  setmetatable(deckClass, metadata)
  
  deckClass.position = Vector(x, y)
  deckClass.cards = {}
  deckClass.zoneType = ZONES.DECK
  deckClass.zoneName = "Deck"
  
  
  return deckClass
end

function DeckClass:addCard(card)
  prevZone = card.zone
  prevIndex = card.index
  card:setZone(self)
  card.zoneType = self.zoneType
  table.insert(self.cards, card)
  if prevZone ~= nil then
    table.remove(prevZone, card.index)
  end
  card.index = #self.cards
  
end
