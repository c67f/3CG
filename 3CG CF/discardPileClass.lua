DiscardPileClass = {}
function DiscardPileClass:new(x, y)
  local discardPile = {}
  local metadata = {__index = DiscardPileClass}
  setmetatable(discardPile, metadata)
  
  discardPile.position = Vector(x, y)
  discardPile.cards = {}
  discardPile.zoneType = ZONES.DISCARD
  discardPile.zoneName = "Discard Pile"
  
  return discardPile
end

function DiscardPileClass:addCard(card)
  prevZone = card.zone
  prevIndex = card.index
  card:setZone(self)
  table.insert(self.cards, card)
  if prevZone ~= nil then
    prevZone:removeCard(card)
    --print(prevZone.zoneName .. prevZone[1].name)
  end
  card.index = #self.cards
  
end
