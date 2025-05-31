CardClass = {}

require "spriteClass"
require "vector"

ZONES = {
    NONE = 0,
    DECK = 1,
    HAND = 2,
    DISCARD = 3,
    LOCATION = 4,
    GRABBER = 5
}

CARDWIDTH = 96
CARDHEIGHT = 128

function CardClass:new(x, y, pow, cost, eff, spriteClass, player)
  local card = {}
  local metadata  = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(x, y)
  card.power = pow
  card.cost = cost
  card.effect = eff --a class which determines the effects of the card (e.g. AthenaEffect, HydraEffect, etc.)
  
  if spriteClass ~= nil then
    card.sc = spriteClass
  else
    card.sc = nil
  end
  
  card.zone = nil --the specific zone (e.g. location1, player1's hand, etc.) a card is in. a zone is anywhere a card can be - a player's hand, a deck, a location, a discard, etc.
  card.zoneType = NONE --the type of zone the card is in
  card.owner = player --which player owns this card
  card.index = 0
  card.scale = 1
  card.flipY = (card.owner.num == 1 and 1 or -1) --determines if cards are drawn flipped 180 degrees - if player num is 1, then no, otherwise (if player 2) yes
  --card.isGrabbed = false --if true, follow the grabber (and therefore the mouse cursor)
  
  
  return card
end

function CardClass:setZone(zone)
  self.zone = zone
end

function CardClass:update()--grabberX, grabberY
  --print(self.power)
  print(self.zone.zoneName)
  --print(self.zone)
  self.zoneType = self.zone.zoneType --always keep self.zoneType of the card (the type of zone the card is in) updated to be the same as the type of zone that self.zone (the object the card is in, e.g. a hand, a location, a deck)
  --print("CardClass:update - self.zoneType is " .. self.zoneType)
  if self.zoneType == ZONES.DECK or self.zoneType == ZONES.DISCARD then
    --print("in deck zone or discard zone")
    self.position = Vector(self.zone.position.x, self.zone.position.y)
  elseif self.zoneType == ZONES.HAND or self.zoneType == ZONES.LOCATION then
    print("in hand zone or location zone")
    self.position = Vector(self.zone.position.x + (self.index-1)*(CARDWIDTH+10), self.zone.position.y) --indices start at 1
    --print(self.zone.zoneName)
    --print(self.zone.position.x)
  elseif self.zoneType == ZONES.GRABBER then --if grabbed, follow the mouse
    print(love.mouse.getX())
    --print(self.zoneType)
    self.position = Vector(love.mouse.getX(), love.mouse.getY())
  end
--last thing done 5/23: card auto moves to hand position if in a hand
end

function CardClass:draw()
  xOffset = CARDWIDTH/2 --card image size is 96 by 128
  yOffset = CARDHEIGHT/2
  sprite = self.sc:getSprite()
  --love.graphics.draw(sprite, 0, 0)
  love.graphics.draw(sprite, self.position.x, self.position.y, 0, self.scale, self.scale * self.flipY, xOffset, yOffset) --origin offset is the last two parameters
  love.graphics.print(self.index .. ", " .. self.zoneType .. ", " .. self.zone.zoneName .. ", " .. self.zone.position.x .. ", " .. self.position.x, self.position.x, self.position.y - 100)
end