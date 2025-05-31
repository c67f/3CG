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

allCards = {}

function love.load()
  love.window.setTitle("3CG")
  love.graphics.setDefaultFilter("nearest", "nearest")
  screenWidth = 860
  screenHeight = 600
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0, 0.8, 0.2)
  
  gameManager = GameManagerClass:new()
  
  cardSpriteTemplate = SpriteClassCardTemplate:new()
  print(cardSpriteTemplate:getSprite())
  buttonSpriteTemplate = SpriteClassButton:new() --5/28 10:06: added button and end turn functionality (not tested). last thing done was realize I need to make subclasses for SpriteClass - made (untested) the card sprite subclass, need to make the button one
  print(buttonSpriteTemplate)
  
  deck1 = DeckClass:new()
  discard1 = DiscardPileClass:new()
  deck2 = DeckClass:new()
  discard2 = DiscardPileClass:new()
  
  player1 = PlayerClass:new(screenWidth, screenHeight, deck1, discard1, 1)
  player2 = PlayerClass:new(screenWidth, screenHeight, deck2, discard2, 2)
  players = {player1, player2}
  print("players number: " .. #players)
  
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
  --print(grabber.test)
  --grabber:grab()
  
  
  gameManager:setupGame(player1, player2, cardSpriteTemplate)
  print("player1 cards in hand is: " .. #player1.hand)
  
  --newCard = CardClass:new(250, 250, 1, 1, nil, cardSpriteTemplate, player1)
  --table.insert(deck1.cards, newCard)
  --newCard2 = CardClass:new(250, 250, 1, 1, nil, cardSpriteTemplate, player1)
  --table.insert(deck1.cards, newCard2)
  --print(#deck1.cards)
  --player1:drawCard(deck1.cards) --why did . instead of : sort of work?)
  --player1:drawCard(deck1.cards)
  --table.insert(player1.hand, newCard)
end

function love.update()
  --print(grabber)
  --grabber:grab()
  player1:update()
  player2:update()
  grabber:update(player1.hand, players, locations) --hmmm...if I use allCards to contain every card (or do something similar) in addition to having each card in its zone's table (e.g. player1.hand) will that work, or will it make duplicates of the cards for each table?
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
  for _, loc in ipairs(locations) do
    --loc:update()
    for _, card in ipairs(loc.p1Cards) do 
      card:update()
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
  for _, card in ipairs(player1.hand) do
    card:draw()
  end
  for _, card in ipairs(player2.hand) do
    card:draw()
  end
  
  p1Button:draw()
end