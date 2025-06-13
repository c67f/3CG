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
  --print(card.name)
  prevZone = card.zone
  prevIndex = card.index
  card:setZone(self)
  table.insert(self.cards, card)
  if prevZone ~= nil then
    prevZone:removeCard(card)
    --print(prevZone.zoneName .. prevZone[1].name)
  end
  card.index = #self.cards
  
  if prevZone.zoneType == ZONES.LOCATION then
    adjustCards(prevZone:getPlayerCards(card.owner.num), prevIndex) --I wasn't adjusting the indices of the previous zone's cards when a card was removed from them
  elseif prevZone.zoneType == ZONES.HAND then
    adjustCards(prevZone.hand, prevIndex)
  else
    --print("prevZone name: " .. prevZone.zoneName)
    adjustCards(prevZone.cards, prevIndex)
  end
  
end

function adjustCards(cards, removedIndex)
  for _, card in ipairs(cards) do
    if card.index > removedIndex then
      card.index = card.index - 1
    end
  end
end
