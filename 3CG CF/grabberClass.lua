GrabberClass = {}

require "cardClass"
require "deckClass"
require "vector"
require "locationClass"
require "playerClass"


function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass} --5/24/2025: last thing done, fixed main not recognizing the functions of grabber by changing __index, GrabberClass to __index = GrabberClass. Before that, implemented grabber object with overlap check on update (wasn't working until I fixed the typo)
  setmetatable(grabber, metadata)
  
  grabber.position = Vector(0, 0) --currently placeholder, just here so "zone.position" for cards works
  grabber.currentMousePos = nil
  grabber.grabbedCard = nil --what card is being grabbed (if any)
  grabber.grabbedSource = nil --where the card was grabbed from
  grabber.test = "test"
  grabber.zoneType = ZONES.GRABBER
  grabber.zoneName = "Grabber"
  
  
  return grabber
end

function GrabberClass:update(cards, hands, locations)
  --print("grabber update")
  self.currentMousePos = Vector(love.mouse.getX(), love.mouse.getY())
  mouseSize = Vector(0,0) --zero vector for the detectOverlap function
  cardSize = Vector(CARDWIDTH, CARDHEIGHT)
  
  for _, card in ipairs(cards) do
    if detectOverlap(mouseSize, cardSize, self.currentMousePos, card.position) then --might want to add a "layer" parameter to cards to deal with what card should be picked up in overlapping cards? But I'm not sure if there will actually be any situations where cards will overlap
      --print("mousing over a card")
      if love.mouse.isDown(1) and self.grabbedCard == nil then
        print("grabbing card")
        self:grab(card)
      end
    end
  end
  
  if not love.mouse.isDown(1) and self.grabbedCard ~= nil then
    releaseZone = self:releaseCheck(hands, locations, self.grabbedCard.owner)
    if releaseZone ~= nil then
      print("releaseZone type: " .. releaseZone.zoneType)
      
      if releaseZone.zoneType == ZONES.LOCATION then
        self.grabbedCard.owner.currMana = self.grabbedCard.owner.currMana - self.grabbedCard.cost --subtract cost from current energy - technically this also will charge you if you picked up from a location and dropped on a location, but currently you can't so it's fine
      end
      self:release(releaseZone, self.grabbedCard)
      
      --print("zone type: " .. self.grabbdCard.zoneType)
    else 
      print("returning card to original location") --return card to where it was picked up from
      --5/26/2025: next steps are putting in the return to pickup location code and finishing the release function
      self.grabbedCard.zone = self.grabbedSource
      self.grabbedCard.zoneType = self.grabbedSource.zoneType
      self.grabbedCard = nil
    end
  end
end


function GrabberClass:grab(card)
  --print("grab")
  self.grabbedSource =  card.zone
  print(card.zone.zoneName)
  card.zone = self
  card.zoneType = ZONES.GRABBER
  self.grabbedCard = card
end

function GrabberClass:releaseCheck(hands, locations, cardOwner)
  cardSize = Vector(CARDWIDTH, CARDHEIGHT)
  
  for _, hand in ipairs(hands) do --check all hands if the grabbed card is overlapping
    if detectOverlap(cardSize, HANDSIZE, self.currentMousePos, hand.position) and hand.num == cardOwner.num then --make sure that the card is being dropped on the hand of the player who owns it --4/28 4:43: Last thing done is add this second condition, previously fixed the location bugs. Next step I think is implement card power values, and an end turn button that triggers player 2 to play a random card to a location and then activates checking the difference in powers at locations
      print("dropping on a hand")
      return hand--ZONES.HAND
    end
  end
  for _, location in ipairs(locations) do --check all 3 locations if the grabbed card is overlapping
    if detectOverlap(cardSize, LOCATIONSIZE, self.currentMousePos, location.position) and cardOwner.currMana >= self.grabbedCard.cost and checkIfFull(location, cardOwner) == false then
      print("dropping on a location")
      --print(location.zoneType)
      
      return location--ZONES.LOCATION
    end
  end
  return nil
end

function GrabberClass:release(zone, card)
  if self.grabbedSource.zoneType == ZONES.HAND then --5/27: locations are now drawn and a bug was fixed with them not being created, picking up from a hand works, as does the cards snapping back when released over an invalid spot. Last thing changed was this line, to grabbedSource insted of zone, since I realized that it currently doesn't matter what the type of the zone your dropping the card onto is (since the function, addCard, is the same), but it does matter what the type of the zone you're removing them from (since players use .hand as their card table while locations don't). Next thing: getting some bugs with dropping cards onto locations - they disappear, , and after dragging and dropping a couple there's a crash/error. Also need to finish coding PlayerClass to update its cards position in the hand.
    --5/28 1:51: fixed the crashing bug by having cards automatically update their zoneType to be their zone's type - I was setting the zone in player (and location) but not the zoneType, this makes that a nonissue
    
    table.remove(self.grabbedSource.hand, card.index) --remove card from the cards table of the object that it was grabbed from
    zone:addCard(card)
    print(card.zone.zoneType)
    self.grabbedCard = nil
    

    
    --print(card.position.x .. ", " .. card.position.y)
  elseif self.grabbedSource.zoneType == ZONES.LOCATION then
    --TODO: Add an additional check to what player the cards are from, and remove from the appropriate players table, since there isn't actually a general "cards" table in locations.
    table.remove(self.grabbedSource.cards, card.index)
    zone:addCard(card)
    self.grabbedCard = nil
    print("grabbed from a location")
    --print(card.zoneType)
    --print(card.position.x)
  else
    print("error!")
  end
end

function detectOverlap(size1, size2, position1, position2) --size 1 and 2 are thesizes of the two checked objects as vectors, and positions 1 and 2 are their positions
  width1 = size1.x 
  width2 = size2.x
  height1 = size1.y 
  height2 = size2.y
  x1 = position1.x - width1/2 --the x coordinate of the top left corner: center position - the horizontal distance from the center of the object
  y1 = position1.y - height1/2
  x2 = position2.x - width2/2 --the y coordinate of the top left corner: center position - the vertical distance from the center of the object
  y2 = position2.y - height2/2
  
  if x1 + width1 > x2 and --rightmost position of 1 is right of leftmost position of 2
  x1 < position2.x + width2 and --leftmost position of 1 is left of rightmost position of 2
  y1 + height1 > y2 and --lowest position of 1 is below highest position of 2
  y1 < y2 + height2 --heighest position of 1 is above lowest posiiton of 2
  then
    return true
  else
    return false
  end
end

function checkIfFull(location, player)
  print(LOCATION_CAP)
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