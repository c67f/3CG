--sandbox pattern, I think

CardDataClass = {}

require "spriteClass"
require "cardEffectClass"

function CardDataClass:new()
  local cardData = {}
  local metadata = {__index, CardDataClass}
  setmetatable(cardData, metadata)
  
  cardData.name = "Base Card"
  cardData.cost = 1
  cardData.power = 1
  cardData.spriteClass = SpriteClassCardTemplate:new()
  cardData.effect = nil
  
  return cardData
end

--The different cards:

--Vanillas:
CowDataClass = CardDataClass:new()
function CowDataClass:new() 
  print("new Wooden Cow")
  self.name = "Wooden Cow"
  --self.spriteClass = TODO: Get different sprites for all the cards
  
  return self
end

PegasusDataClass = CardDataClass:new()
function PegasusDataClass:new()
  self.name = "Pegasus"
  self.cost = 3
  self.power = 5
  
  return self
end

MinotaurDataClass = CardDataClass:new()
function MinotaurDataClass:new()
  self.name = "Minotaur"
  self.cost = 5
  self.power = 9
  
  return self
end

TitanDataClass = CardDataClass:new()
function TitanDataClass:new()
  self.name = "Titan"
  self.cost = 6
  self.power = 12
  
  return self
end

--Non-vanillas:
ArtemisDataClass = CardDataClass:new()
function ArtemisDataClass:new()
  self.name = "Artemis"
  self.cost = 3
  self.power = 4
  --self.spriteClass = 
  self.effect = ArtemisEffectClass:new(self)
  
  return self
end