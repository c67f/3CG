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
    --print("no cards in cpu player's hand")
    return
  end
  
  --6/12/2025: last thing done: new cpu logic implemented and seems to be now working without any bugs (yay! also knock on wood), next thing might be to put it in a loop to do multiple cards until out of mana
  --1: Check that there’s at least one open location, and add the num/id of any open locations to a list of all open ones
  allFull = true
  openLocations = {}
  for _, loc in ipairs(locations) do
    if checkIfFull(loc, self.playerObj) ~= true then
      allFull = false
      table.insert(openLocations, loc.num)
    end
  end
  if allFull == false then
    
      --2: For each card in the cpu player's hand, if the card is less than or equal to their current mana, add the card's index to playableCards
    playableCards = {}
    --print(self.playerObj.currMana)
    for _, card in ipairs(self.playerObj.hand) do
      if card.cost <= self.playerObj.currMana then
        table.insert(playableCards, card)
      end
    end
    if #playableCards > 0 then
  
      --3: Get what not-full (for p2) location p2 is losing by the most, or winning by the least. If there's a tie for that, choose at random
      losingLocation = 0
      --print("losinglocation " .. losingLocation)
      tiedLocations = {}
      chosenLocation = nil
      --print("openLocations[1] = " .. openLocations[1]) 
      --print("locations[1].num is " .. locations[1].num)
      --print(locations[openLocations[1]]:getPowerDiff())
      --print(locations[1]:getPowerDiff())
      --print("#openLocations is " .. #openLocations)
      for i = 1, #openLocations do
--        if losingLocation == 0 then
--          print("losingLocation = 0")
--          print("losingLocation: " .. losingLocation)
--        else
--          print("losingLocation: " .. losingLocation)
--          print("powerDiffs in loop:")
--          print(locations[openLocations[1]]:getPowerDiff())
--          print(locations[1]:getPowerDiff())
--        end
--        print("test")
        if losingLocation == 0 or locations[openLocations[i]]:getPowerDiff() > locations[losingLocation]:getPowerDiff() then
          losingLocation = locations[openLocations[i]].num --was setting it to the location instead of setting it to the num
        elseif losingLocation ~= 0 and locations[openLocations[i]]:getPowerDiff() == locations[losingLocation]:getPowerDiff() then --if currently checked location ties with the previously found losingLocation
          if checkIfInTable(tiedLocations, losingLocation) then --if we didn't already add losingLocation to the tied locations table
            table.insert(tiedLocations, losingLocation)
          end
          table.insert(tiedLocations, locations[openLocations[i]].num)
        end
      end
      if #tiedLocations > 0 then
        math.randomseed(os.time())
        randLocIndex = tiedLocations[math.random(#tiedLocations)]
        randLoc = locations[randLocIndex]
        
        while checkIfFull(randLoc, self.playerObj) == true do
          randLocIndex = math.random(tiedLocations)
          randLoc = locations[randLocIndex]
        end
        --print("random location: " .. randLocIndex)
        chosenLocation = randLoc
        --print("chosen random location: " .. chosenLocation.num)
      else
        chosenLocation = locations[losingLocation]
      end
      --print("chosenLocation: " .. chosenLocation.num)
      
      --4: Choose the playable card with the highest power and play it to the chosen location. if a tie, the card that comes first in playableCards will be chosen
      highestPowCard = nil
      for _, card in ipairs(playableCards) do
        if highestPowCard == nil or card.power > highestPowCard.power then
          highestPowCard = card
        end
      end
      table.remove(self.playerObj.hand, highestPowCard.index)
      chosenLocation:addCard(highestPowCard)
      --print("played " .. highestPowCard.name .. " to location #" .. randLocIndex)
    else
      --print("no card to play")
    end
  else
    --print("no open locations")
  end
  
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

function checkIfInTable(table, value) --utility function to check if a given value exists in a table
  inTable = false
  for _, val in ipairs(table) do
    if val == value then
      inTable = true
    end
  end
  return inTable
end