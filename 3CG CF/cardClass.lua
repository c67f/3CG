CardClass = {}

require "spriteClass"
require "cardDataClass"
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

function CardClass:new(x, y, data, player) --pow, cost, eff, spriteClass, 
  local card = {}
  local metadata  = {__index = CardClass}
  setmetatable(card, metadata)
  
  --print(player)
  
  card.position = Vector(x, y)
  card.name = data.name
  card.power = data.power
  card.cost = data.cost
  card.description = data.description
  --print("new card")
  if data.effect ~= nil then
    --print("dataclass not nil")
    card.effect = data.effect:new(card) --a class which determines the effects of the card (e.g. AthenaEffect, HydraEffect, etc.)
    --print(card.effect.card)
  end
  --if spriteClass ~= nil then
  card.sc = data.spriteClass
  --else
    --card.sc = nil
  --end
  
  card.zone = nil --the specific zone (e.g. location1, player1's hand, etc.) a card is in. a zone is anywhere a card can be - a player's hand, a deck, a location, a discard, etc.
  card.zoneType = NONE --the type of zone the card is in
  card.owner = player --which player owns this card
  card.index = 0
  card.revealed = true
  
  card.scale = 1
  card.flipY = (card.owner.num == 1 and 1 or -1) --determines if cards are drawn flipped 180 degrees - if player num is 1, then no, otherwise (if player 2) yes
  --card.isGrabbed = false --if true, follow the grabber (and therefore the mouse cursor)
  
  
  return card
end

function CardClass:setZone(zone)
  self.zone = zone
end

function CardClass:update()--grabberX, grabberY
  self.zoneType = self.zone.zoneType --always keep self.zoneType of the card (the type of zone the card is in) updated to be the same as the type of zone that self.zone (the object the card is in, e.g. a hand, a location, a deck)
  if self.zoneType == ZONES.DECK or self.zoneType == ZONES.DISCARD then
    --print("in deck zone or discard zone")
    self.revealed = false
    self.position = Vector(self.zone.position.x, self.zone.position.y)
  elseif self.zoneType == ZONES.HAND then
    --print("in hand zone or location zone")
    self.revealed = true
    self.scale = 1 --reset scale to full size
    self.position = Vector(self.zone.position.x + (self.index - 1) * (CARDWIDTH + 10), self.zone.position.y) --indices start at 1
  elseif self.zoneType == ZONES.LOCATION then
    self.scale = 0.5 --make smaller to fit
    self.position = Vector(self.zone.position.x + (self.index - 1) * (CARDWIDTH * self.scale + 10) - CARDWIDTH * self.scale, self.zone.position.y + self.flipY*CARDHEIGHT*self.scale)
  elseif self.zoneType == ZONES.GRABBER then --if grabbed, follow the mouse
    --print(love.mouse.getX())
    self.revealed = true
    self.position = Vector(love.mouse.getX(), love.mouse.getY())
  end
--last thing done 5/23: card auto moves to hand position if in a hand
end

function CardClass:draw()
  xOffset = CARDWIDTH/2 --card image size is 96 by 128
  yOffset = CARDHEIGHT/2
  if self.revealed == true then
    sprite = self.sc:getSprite(1)
  else
    sprite = self.sc:getSprite(2) --draw as face down if not revealed
  end
  --love.graphics.draw(sprite, 0, 0)
  love.graphics.draw(sprite, self.position.x, self.position.y, 0, self.scale, self.scale * self.flipY, xOffset, yOffset) --origin offset is the last two parameters
  if self.revealed == true then
    love.graphics.setColor(0, 0, 0.5)
    love.graphics.setFont(cardFont)
    love.graphics.print(self.cost .. ", " .. self.power, self.position.x - 10, self.position.y + 65*self.scale)
    love.graphics.printf(self.name, self.position.x - 45, self.position.y - 104, CARDWIDTH, "left")
  end
  love.graphics.setColor(1, 1, 1)
  --love.graphics.print(self.owner.num .. "," .. self.index .. ", " .. self.zoneType .. ", " .. self.zone.zoneName .. ", " .. self.zone.position.x .. ", " .. self.position.x, self.position.x, self.position.y - 100)
end



--ArtemisCardClass = CardClass:new()
--function ArtemisCardClass:new(x, y, data, player)
--  self.position = Vector(x,y)
--  self.name = data.name
--  self.power = data.power
--  self.cost = data.cost
--  self.sc = data.spriteClass
  
--  return self
--end





--function 
--  self.power = self.power + 1
--  if self.power > 7 then
--    self:discard()
--end
