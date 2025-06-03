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

ArtemisEffectClass = CardEffectClass:new()

function ArtemisEffectClass:new(o)
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
    if self.card.zone:getPlayerCards(self.card.owner.num) then
      self.card.power = self.card.power + 5
    end
  end
end

--utility functions
--function C