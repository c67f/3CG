LocationClass = {}

require "cardClass"
require "playerClass"
require "vector"

LOCATIONSIZE = Vector(150, 150)

function LocationClass:new(x, y, num)
  local location = {}
  local metadata = {__index = LocationClass}
  setmetatable(location, metadata)
  
  location.num = num --1, 2, or 3
  location.position = Vector(x, y)
  location.p1Cards = {}
  location.p2Cards = {}
  location.p1Power = 0
  location.p2Power = 0
  --location.p1Cost maybe later
  --location.p2Cost
  location.zoneType = ZONES.LOCATION
  location.zoneName = "Location " .. location.num
  
  return location
end

function LocationClass:draw()
  --print("drawing location")
  offset = Vector(LOCATIONSIZE.x/2, LOCATIONSIZE.y/2)
  love.graphics.setColor(1, 1, 0.9)
  love.graphics.rectangle("fill", self.position.x - offset.x, self.position.y - offset.y, LOCATIONSIZE.x, LOCATIONSIZE.y)
end

function LocationClass:addCard(card)
  --card.zone = self
  card:setZone(self)
  --card.zoneType = 3
  if card.owner.num == 1 then
    print("adding to p1 cards")
    table.insert(self.p1Cards, card)
    card.index = #self.p1Cards
  elseif card.owner.num == 2 then
    print("adding to p1 cards")
    table.insert(self.p2Cards, card)
    card.index = #self.p2Cards
  else
    print("error! tried to add a card owned by a player that isn't 1 or 2 to a location")
  end
end

function LocationClass:getPowerDiff()
  self.p1Power = 0
  self.p2Power = 0
  for _, card in self.p1Cards() do
    self.p1Power = self.p1Power + card.power
  end
  for _, card in self.p2Cards() do
    self.p2Power = self.p2Power + card.power
  end
  diff = self.p1Power - self.p2Power
  return diff --positive diff means p1 has more power, negative means p2 does
end