io.stdout:setvbuf("no") --print messages immediately

require "playerClass"
require "cardClass"
require "deckClass"
require "discardPileClass"
require "spriteClass"
require "gameManagerClass"
require "grabberClass"
require "locationClass"
require "buttonClass"
require "CPUPlayerClass"

allCards = {}

TITLE = "Battle of Myths"

function love.load()
  love.window.setTitle("3CG")
  love.graphics.setDefaultFilter("nearest", "nearest")
  screenWidth = 1060
  screenHeight = 800
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0, 0.8, 0.2)
  
  --Sprites
  
  buttonSpriteTemplate = SpriteClassButton:new() --5/28 10:06: added button and end turn functionality (not tested). last thing done was realize I need to make subclasses for SpriteClass - made (untested) the card sprite subclass, need to make the button one
  --sprites = {cardSpriteTemplate, buttonSpriteTemplate}
  
  --Deck and discard piles
  deck1 = DeckClass:new(-200, 250)
  discard1 = DiscardPileClass:new(0, 0)
  deck2 = DeckClass:new(1000, 250)
  discard2 = DiscardPileClass:new(500, 500)
  
  --Create player objects
  player1 = PlayerClass:new(screenWidth, screenHeight, deck1, discard1, 1)
  player2 = PlayerClass:new(screenWidth, screenHeight, deck2, discard2, 2)
  players = {player1, player2}
  print("players number: " .. #players)
  
  --Create locations
  loc1 = LocationClass:new(100, screenHeight/2, 1)
  loc2 = LocationClass:new(screenWidth/2, screenHeight/2, 2)
  loc3 = LocationClass:new(screenWidth-100, screenHeight/2, 3)
  locations = {loc1, loc2, loc3}
  print(loc1)
  print("locations number: " .. #locations)
  
  p1Button = TurnButtonClass:new(screenWidth - (BUTTON_SIZE.x * 1) , screenHeight - (BUTTON_SIZE.y * 2), buttonSpriteTemplate)
  print (p1Button.sc)
  print(p1Button)
  p1Button:test()
  
  grabber = GrabberClass:new()
  
  cpuPlayer = CPUPlayerClass:new(player2)
  
  --default deck lists:
  decklist1 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 1, 3, 3, 3, 2, 4, 13, 14, 13, 12, 11, 13, 9, 8, 1, 12, 5}
  decklist2 = {4, 5, 4, 1, 1, 1, 4, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 9, 3, 3, 3, 4, 2, 1, 4, 4, 1, 2, 1, 1, 8}
  print("size of decklist1 is " .. #decklist1)
  
  --Create gameManager and setup game:
  gameManager = GameManagerClass:new(player1, cpuPlayer, locations)--sprites
  gameManager:setupGame(decklist1, decklist2)
  print("player1 cards in hand is: " .. #player1.hand)
end

function love.update()
  --Update players
  player1:update()
  player2:update()
  --Update grabber
  grabber:update(player1.hand, players, locations) --hmmm...if I use allCards to contain every card (or do something similar) in addition to having each card in its zone's table (e.g. player1.hand) will that work, or will it make duplicates of the cards for each table?
  --Update end turn button
  p1Button:update(gameManager)
  
  for _, card in ipairs(player1.hand) do 
    --print("card zone:")
    --print(card.zone)
    card:update()
  end
  for _, card in ipairs(player2.hand) do 
    --print("card zone:")
    --print(card.zone)
    card:update()
  end
  for _, card in ipairs(deck1.cards) do --forgot to do .cards
    --print(card.zone.zoneName)
    card:update()
  end
  for _, card in ipairs(deck2.cards) do
    card:update()
  end
  for _, card in ipairs(discard1.cards) do
    card:update()
  end
  for _, card in ipairs(discard2.cards) do
    card:update()
  end
  for _, loc in ipairs(locations) do
    --loc:update()
    for _, card in ipairs(loc.p1Cards) do 
      card:update()
--      if card.name == "Helios" then
--        print("helios in location")
--      end
    end
    for _, card in ipairs(loc.p2Cards) do
      card:update()
    end
  end
end

function love.draw()
  --love.graphics.rectangle("fill", 100, 100, 400, 400)
  --test = love.graphics.newImage("Images/CardTemplate.png")
  --love.graphics.draw(test, 100, 100)
  --print(#locations)
  
  for _, loc in ipairs(locations) do
    loc:draw()
    for _, card in ipairs(loc.p1Cards) do --5/28 2:06: cards dropping but not arranging themselves? EDIT: wasn't updating the cards in locations
      card:draw()
    end
    for _, card in ipairs(loc.p2Cards) do
      card:draw()
    end
  end
  
  --print(#player1.hand)
  for _, card in ipairs(player1.hand) do
    card:draw()
  end
  for _, card in ipairs(player2.hand) do
    card:draw()
  end
  
  for _, card in ipairs(deck1.cards) do
    card:draw()
  end
  for _, card in ipairs(deck2.cards) do
    card:draw()
  end
  for _, card in ipairs(discard1.cards) do
    card:draw()
  end
  for _, card in ipairs(discard2.cards) do
    card:draw()
  end
  
  p1Button:draw()
  
  love.graphics.print(TITLE, 450, 750, 0, 3)
  love.graphics.print("p1: " .. player1.score, 10, 10)
  love.graphics.print("p2: " .. player2.score, 10, 40)
  love.graphics.print("p1 energy: " .. player1.currMana, 10, 500)
  love.graphics.print("p2 energy: " .. player2.currMana, 700, 30)
  love.graphics.print("p1 discard pile count: " .. #player1.discardPile, 10, 420)
  love.graphics.print("p2 discard pile count: " .. #player2.discardPile, 700, 50)
end