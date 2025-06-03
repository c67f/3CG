PlayerClass = {}

require "cardClass"
require "deckClass"
require "vector"

HANDSIZE = Vector(860, 150) --hand area is screen width by height equal to a little more than card height

function PlayerClass:new(screenWidth, screenHeight, deck, discard, num) --num is player one or player two
  local player = {}
  local metadata = {__index = PlayerClass}
  setmetatable(player, metadata)
  
  player.hand = {}
  player.deck = deck
  player.discardPile = discard
  player.num = num
  player.score = 0
  player.isTurn = false --whether it's this player's turn
  player.zoneType = ZONES.HAND --for accessing by grabber, to get the zone type for what a card is being dropped on
  player.currMana = 0
  
  
  player.position = Vector(screenWidth/5, 0)
 --placeholder, should be 1/2 screen width
  if num == 1 then
    player.position.y = screenHeight - screenHeight/7 --placeholder, should be a bit before the bottom of the screen
  else
    player.position.y = screenHeight/7
  end
  player.lastCardPlayed = nil
  player.zoneName = "Player " .. player.num
  
  return player
end

function PlayerClass:update()
  self:handUpdate()
end

function PlayerClass:handUpdate()
  for _, card in ipairs(self.hand) do
    card.index = _
    --print(card.index)
  end
end

function PlayerClass:addCard(card)
  card.zone = self
  print(card.zoneType)
  table.insert(self.hand, card)
  card.index = #self.hand
end

function PlayerClass:drawCard(deckCards) --probably should change this to use self.deck, but want to figure out this problem first
  --deck.cards = cards
  --print(deckCards)
  --print(#deckCards)
  table.insert(self.hand, deckCards[#deckCards]) --top card of deck is last card in table
  print("new card added: " .. self.hand[#self.hand].power)
  table.remove(deckCards, #deckCards)
  print("new card added after card removed from deck is hopefully still the same: " .. self.hand[#self.hand].power)
  
  newCard = self.hand[#self.hand]
  newCard.zone = self-- = HAND1 --why can't I do newCard:setZone(self)?
  newCard.zoneType = ZONES.HAND --Note: Need to make sure to set the zone type whenever I move a card to a different type of zone
  print(newCard.zoneType)
  newCard.index = #self.hand --gotta make sure to update the index of a card whenever it moves zones (at least to a location or hand zone, anyway)
  print(newCard.zone)
end
