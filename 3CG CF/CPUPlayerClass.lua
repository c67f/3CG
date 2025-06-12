CPUPlayerClass = {}

require "playerClass"
require "cardClass"
require "locationClass"

function CPUPlayerClass:new(player) --5/31 next step: CPU player and with it the full game flow (p1 turn -> p2 turn -> p1 turn -> etc.) After that, visible scores and a win check
  local cpuPlayer = {}
  local metadata = {__index = CPUPlayerClass}
  setmetatable(cpuPlayer, metadata)
  
  self.playerObj = player
  self.timer = 0
  
  return cpuPlayer
end

--function CPUPlayerClass:update()
--  self.timer = self.timer + love.timer.getDelta
--end

function CPUPlayerClass:playCard(locations)
  if #self.playerObj.hand < 1 then --if there aren't cards in hand, return
    print("no cards in cpu player's hand")
    return
  end
  
  
  --1: Check that there’s an open location
--  allFull = true
--  for _, loc in ipairs(locations) do
--    if checkIfFull ~= true then
--      allFull = false
--    end
--  end
  --if allFull == false then
  
  --pick random location:
  math.randomseed(os.time())
  randLocIndex = math.random(#locations)
  randLoc = locations[randLocIndex]
  
  while checkIfFull(randLoc, self.playerObj) == true do
    randLocIndex = math.random(#locations)
    randLoc = locations[randLocIndex]
  end
  print("random location: " .. randLocIndex)
  
  randCard = self:getRandomCard()
  print(randCard.cost)
  print(self.playerObj.currMana)
  searchCount = 1
  while randCard.cost > self.playerObj.currMana and searchCount < #self.playerObj.hand do
    --if the random card picked has mana cost greater than current mana, choose a new random card, and continue until you get a playable card or you go through all cards
    randCard = self:getRandomCard() --last thing done 5/31, started beginnings of mana check in cpu player
    searchCount = searchCount + 1
    print("searchCount: " .. searchCount)
  end
  
  if searchCount < #self.playerObj.hand then --if a playable card was found
    table.remove(self.playerObj.hand, randCard.index)
    randLoc:addCard(randCard)
    print("played " .. randCard.name .. " to location #" .. randLocIndex)
  else
    print("no card to play")
  end
  --end
  
end

function CPUPlayerClass:getRandomCard()
  math.randomseed(os.time())
  randIndex = math.random(#self.playerObj.hand)
  randomCard = self.playerObj.hand[randIndex]
  return randomCard
end

function checkIfFull(location, player)
  if player.num == 1 then
    if #location.p1Cards > LOCATION_CAP - 1 then
      return true
    end
  else 
    if #location.p2Cards > LOCATION_CAP - 1 then
      return true
    end
  end
  return false
end