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
  self.cost = 4
  self.power = 4
  self.spriteClass = SpriteClassArtemis:new()
  self.effect = ArtemisEffectClass:new()
  
  return self
end

AresDataClass = CardDataClass:new()  --6/4 last thing done: created ares card data and effect
function AresDataClass:new()
  self.name = "Ares"
  self.cost = 4
  self.power = 2
  --self.spriteClass = 
  self.effect = AresEffectClass:new()
  
  return self
end

HeliosDataClass = CardDataClass:new()
function HeliosDataClass:new()
  self.name = "Helios"
  self.cost = 4
  self.power = 10
  --self.spriteClass =
  self.effect = HeliosEffectClass:new()
  
  return self
end

DionysusDataClass = CardDataClass:new()
function DionysusDataClass:new()
  self.name = "Dionysus"
  self.cost = 5
  self.power = 7
  --self.spriteClass =
  self.effect = DionysusEffectClass:new()

  return self
end

IcarusDataClass = CardDataClass:new()
function IcarusDataClass:new()
  self.name = "Icarus"
  self.cost = 2
  self.power = 0
  --self.spriteClass =
  self.effect = IcarusEffectClass:new()

  return self
end

PandoraDataClass = CardDataClass:new()
function PandoraDataClass:new()
  self.name = "Pandora"
  self.cost = 3
  self.power = 6
  --self.spriteClass =
  self.effect = PandoraEffectClass:new()

  return self
end

AtlasDataClass = CardDataClass:new()
function AtlasDataClass:new()
  self.name = "Atlas"
  self.cost = 4
  self.power = 8
  --self.spriteClass =
  self.effect = AtlasEffectClass:new()

  return self
end

HerculesDataClass = CardDataClass:new()
function HerculesDataClass:new()
  self.name = "Hercules"
  self.cost = 4
  self.power = 6
  --self.spriteClass =
  self.effect = HerculesEffectClass:new()

  return self
end

SwordDataClass = CardDataClass:new()
function SwordDataClass:new()
  self.name = "Sword of Damocles"
  self.cost = 5
  self.power = 10
  --self.spriteClass =
  self.effect = SwordEffectClass:new()

  return self
end

NyxDataClass = CardDataClass:new()
function NyxDataClass:new()
  self.name = "Nyx"
  self.cost = 6
  self.power = 13
  --self.spriteClass =
  self.effect = NyxEffectClass:new()

  return self
end

PersephoneDataClass = CardDataClass:new()
function PersephoneDataClass:new()
  self.name = "Persephone"
  self.cost = 3
  self.power = 7
  --self.spriteClass =
  self.effect = PersephoneEffectClass:new()
  
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