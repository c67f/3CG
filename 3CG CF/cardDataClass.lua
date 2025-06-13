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
  cardData.description = "base description"
  
  return cardData
end

--The different cards:

--Vanillas:
CowDataClass = CardDataClass:new()
function CowDataClass:new() 
  --print("new Wooden Cow")
  self.name = "Wooden Cow"
  self.description = "Vanilla"
  --self.spriteClass = TODO: Get different sprites for all the cards
  
  return self
end

PegasusDataClass = CardDataClass:new()
function PegasusDataClass:new()
  self.name = "Pegasus"
  self.cost = 3
  self.power = 5
  self.description = "Vanilla"
  
  return self
end

MinotaurDataClass = CardDataClass:new()
function MinotaurDataClass:new()
  self.name = "Minotaur"
  self.cost = 5
  self.power = 9
  self.description = "Vanilla"
  
  return self
end

TitanDataClass = CardDataClass:new()
function TitanDataClass:new()
  self.name = "Titan"
  self.cost = 6
  self.power = 12
  self.description = "Vanilla"
  
  return self
end

--Non-vanillas:
ArtemisDataClass = CardDataClass:new()
function ArtemisDataClass:new()
  self.name = "Artemis"
  self.cost = 4
  self.power = 4
  self.spriteClass = SpriteClassArtemis:new()
  self.effect = ArtemisEffectClass:new()
  self.description = "When Revealed: Gain +5 power if there is exactly one enemy card here."
  
  return self
end

AresDataClass = CardDataClass:new()  --6/4 last thing done: created ares card data and effect
function AresDataClass:new()
  self.name = "Ares"
  self.cost = 4
  self.power = 2
  --self.spriteClass = 
  self.effect = AresEffectClass:new()
  self.description = "When Revealed: Gain +2 power for each enemy card here."
  
  return self
end

HeliosDataClass = CardDataClass:new()
function HeliosDataClass:new()
  self.name = "Helios"
  self.cost = 4
  self.power = 10
  --self.spriteClass =
  self.effect = HeliosEffectClass:new()
  self.description = "End of Turn, if on the field: destroy this card"
  
  return self
end

DionysusDataClass = CardDataClass:new()
function DionysusDataClass:new()
  self.name = "Dionysus"
  self.cost = 5
  self.power = 7
  --self.spriteClass =
  self.effect = DionysusEffectClass:new()
  self.description = "When Revealed: Gain +2 power for each of your other cards here."

  return self
end

IcarusDataClass = CardDataClass:new()
function IcarusDataClass:new()
  self.name = "Icarus"
  self.cost = 2
  self.power = 0
  --self.spriteClass =
  self.effect = IcarusEffectClass:new()
  self.description = "End of Turn, if on the field: increase own power by 1. Then, destroy self if power is greater than 6"

  return self
end

PandoraDataClass = CardDataClass:new()
function PandoraDataClass:new()
  self.name = "Pandora"
  self.cost = 3
  self.power = 6
  --self.spriteClass =
  self.effect = PandoraEffectClass:new()
  self.description = "On Reveal: if no other allied cards are at the same location, lower power by 5"

  return self
end

AtlasDataClass = CardDataClass:new()
function AtlasDataClass:new()
  self.name = "Atlas"
  self.cost = 4
  self.power = 8
  --self.spriteClass =
  self.effect = AtlasEffectClass:new()
  self.description = "End of Turn: if your side of this location is full (4 cards), lower own power by 1"

  return self
end

HerculesDataClass = CardDataClass:new()
function HerculesDataClass:new()
  self.name = "Hercules"
  self.cost = 4
  self.power = 6
  --self.spriteClass =
  self.effect = HerculesEffectClass:new()
  self.description = "On Reveal: if this card has the greatest power at this location, double own power"

  return self
end

SwordDataClass = CardDataClass:new()
function SwordDataClass:new()
  self.name = "Sword of Damocles"
  self.cost = 5
  self.power = 10
  --self.spriteClass =
  self.effect = SwordEffectClass:new()
  self.description = "End of Turn: lose 1 power if you are not winning this location"

  return self
end

NyxDataClass = CardDataClass:new()
function NyxDataClass:new()
  self.name = "Nyx"
  self.cost = 6
  self.power = 13
  --self.spriteClass =
  self.effect = NyxEffectClass:new()
  self.description = "On Reveal: destroy all other allied cards at this location and add their cumulative power to self"

  return self
end

PersephoneDataClass = CardDataClass:new()
function PersephoneDataClass:new()
  self.name = "Persephone"
  self.cost = 3
  self.power = 7
  --self.spriteClass =
  self.effect = PersephoneEffectClass:new()
  self.description = "On Reveal: the lowest power card from your hand is discarded"
  
  return self
end
--and
--Hades

--Template:
--function DataClass:new()
--  self.name = ""
--  self.cost =
--  self.power = 
--  --self.spriteClass =
--  self.effect = EffectClass:new()
--
--  return self
--end