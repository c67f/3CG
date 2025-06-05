CardEffectClass = {} --5/31/2025: cpu player is working as is scoring. Might want to add a timer system to the CPU player so it doesn't play it's card instantly, but that seems like it will take some reworking since there's no easy "wait" function in love2d/lua, so it's fine for now. Next thing is adding the mana system and then implementing some different cards, both with different powers but especially now with card effects

TRIGGER_IDS = {
  NONE = 0,
  REVEAL = 1,
  EOT = 2
}

function CardEffectClass:new(o)
  local cardEffect = {}
  local metadata = {__index = CardEffectClass}
  setmetatable(cardEffect, metadata)
  
  cardEffect.name = "BaseEffect"
  cardEffect.trigger = 0 --when in a turn a card is triggerd
  owner = o
  
  return cardEffect
end

--Artemis: When Revealed: Gain +5 power if there is exactly one enemy card here.
ArtemisEffectClass = CardEffectClass:new()

function ArtemisEffectClass:new(c)
  local artemisEffect = {}
  local metadata = {__index = ArtemisEffectClass}
  setmetatable(artemisEffect, metadata)
  
  artemisEffect.name = "ArtemisEffect"
  artemisEffect.trigger = TRIGGER_IDS.REVEAL
  artemisEffect.card = c
  
  return artemisEffect
end

function ArtemisEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    otherPlayerCards = self.card.zone:getPlayerCards(otherPlayer(self.card.owner.num))
    otherPlayerCardsNum = cardCount(otherPlayerCards)
      
    if otherPlayerCardsNum < 2 then
      print("other player's cards " .. otherPlayerCardsNum)--#self.card.zone:getPlayerCards(otherPlayer(self.card.owner.num)))
      print(#self.card.zone.p2Cards)
      self.card.power = self.card.power + 5
    end
  end
end

--Ares: When Revealed: Gain +2 power for each enemy card here.
AresEffectClass = CardEffectClass:new()

function AresEffectClass:new(c)
  local aresEffect = {}
  local metadata = {__index = AresEffectClass}
  setmetatable(aresEffect, metadata)
  
  aresEffect.name = "AresEffect"
  aresEffect.trigger = TRIGGER_IDS.REVEAL
  aresEffect.card = c
  
  return aresEffect
end

function AresEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    otherPlayerCards = self.card.zone:getPlayerCards(otherPlayer(self.card.owner.num))
    otherPlayerCardsNum = cardCount(otherPlayerCards)
    self.card.power = self.card.power + 2 * otherPlayerCardsNum
  end
end

--Helios: At end of turn, discard this card (from the field)
HeliosEffectClass = CardEffectClass:new()
function HeliosEffectClass:new(c)
  local heliosEffect = {}
  local metadata = {__index = HeliosEffectClass}
  setmetatable(heliosEffect, metadata)
  
  heliosEffect.name = "HeliosEffect"
  heliosEffect.trigger = TRIGGER_IDS.EOT
  heliosEffect.card = c
  heliosEffect.time = 0
  
  return heliosEffect
end

function HeliosEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION and self.time == 0 then
    self.time = 1
    print("next turn helios is discarded") --6/3 4:11: last thing done is make it so Helios isn't discarded before he can be revealed, also before that got discard piles working and not being able to play cards with a higher cost than the player's mana/energy for player 1
  elseif self.card.zoneType == ZONES.LOCATION and self.time == 1 then
    print("helios effect")
    self.card.owner.discardPile:addCard(self.card)
  end
end

--Dionysus: When Revealed: Gain +2 power for each of your other cards here.
DionysusEffectClass = CardEffectClass:new()
function DionysusEffectClass:new(c)
  local dionysusEffect = {}
  local metadata = {__index = DionysusEffectClass}
  setmetatable(dionysusEffect, metadata)

  dionysusEffect.name = "DionysusEffect"
  dionysusEffect.trigger = TRIGGER_IDS.REVEAL
  dionysusEffect.card = c

  return dionysusEffect
end

function DionysusEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    print("other cards: " .. #self.card.zone:getPlayerCards(self.card.owner.num))
    otherCardsNum = #self.card.zone:getPlayerCards(self.card.owner.num) - 1
    self.card.power = self.card.power + 2*otherCardsNum
  end
end

IcarusEffectClass = CardEffectClass:new()
function IcarusEffectClass:new(c)
  local IcarusEffect = {}
  local metadata = {__index = IcarusEffectClass}
  setmetatable(IcarusEffect, metadata)

  IcarusEffect.name = "Icarus"
  IcarusEffect.trigger = TRIGGER_IDS.EOT
  IcarusEffect.card = c

  return IcarusEffect
end

function IcarusEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    self.card.power = self.card.power + 1
    if self.card.power > 6 then
      self.card.owner.discardPile:addCard(self.card)
    end
  end
end

PandoraEffectClass = CardEffectClass:new()
function PandoraEffectClass:new(c)
  local pandoraEffect = {}
  local metadata = {__index = PandoraEffectClass}
  setmetatable(pandoraEffect, metadata)

  pandoraEffect.name = "Pandora"
  pandoraEffect.trigger = TRIGGER_IDS.REVEAL
  pandoraEffect.card = c

  return pandoraEffect
end

function PandoraEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    otherCardsNum = #self.card.zone:getPlayerCards(self.card.owner.num) - 1
    if otherCardsNum < 1 then
      self.card.power = self.card.power - 5
    end
  end
end

AtlasEffectClass = CardEffectClass:new()
function AtlasEffectClass:new(c)
  local atlasEffect = {}
  local metadata = {__index = AtlasEffectClass}
  setmetatable(atlasEffect, metadata)

  atlasEffect.name = "Atlas"
  atlasEffect.trigger = TRIGGER_IDS.EOT
  atlasEffect.card = c

  return atlasEffect
end

function AtlasEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    if #self.card.zone:getPlayerCards(self.card.owner.num) == LOCATION_CAP then
      self.card.power = self.card.power - 1
    end
  end
end

HerculesEffectClass = CardEffectClass:new()
function HerculesEffectClass:new(c)
  local herculesEffect = {}
  local metadata = {__index = HerculesEffectClass}
  setmetatable(herculesEffect, metadata)

  herculesEffect.name = "Hercules"
  herculesEffect.trigger = TRIGGER_IDS.REVEAL
  herculesEffect.card = c

  return herculesEffect
end

function HerculesEffectClass:effect()
  if self.card.zoneType == ZONES.LOCATION then
    otherCards = self.card.zone:getPlayerCards(self.card.owner.num)
    strongest = true
    for _, card in ipairs(otherCards) do
      if card.power > self.card.power then
        strongest = false
      end
    end
    if strongest == true then
      self.card.power = self.card.power*2
    end
  end
end

SwordEffectClass = CardEffectClass:new()
function SwordEffectClass:new(c)
  local swordEffect = {}
  local metadata = {__index = SwordEffectClass}
  setmetatable(swordEffect, metadata)

  swordEffect.name = "Sword of Damocles"
  swordEffect.trigger = TRIGGER_IDS.EOT
  swordEffect.card = c

  return swordEffect
end

function SwordEffectClass:effect()
  print("swordEffect")
  if self.card.zoneType == ZONES.LOCATION then
    if self.card.owner.num == 1 then
      print("power diff is " .. self.card.zone:getPowerDiff())
      if self.card.zone:getPowerDiff() <= 0 then
        self.card.power = self.card.power - 1
      end
    else
      if self.card.zone:getPowerDiff() >= 0 then
        print("power diff is " .. self.card.zone:getPowerDiff())
        self.card.power = self.card.power - 1
      end
    end
  end
end


--EffectClass template:
--function EffectClass:new(c)
--  local Effect = {}
--  local metadata = {__index = EffectClass}
--  setmetatable(Effect, metadata)
--
--  Effect.name = ""
--  Effect.trigger = TRIGGER_IDS.
--  Effect.card = c
--
--  return Effect
--end

--utility functions
function otherPlayer(num)
  if num == 1 then
    return 2
  else
    return 1
  end
end

function cardCount(cards)
  cardsNum = 0 --0 if nil
  if cards ~= nil then
    cardsNum = #cards
  elseif cards == nil then
    cardsNum = 0
  end
  return cardsNum
end