ButtonClass = {}

require "vector"
require "gameManagerClass"

BUTTON_SIZE = Vector(220, 100) --base image is too big

function ButtonClass:new(x, y, spriteClass)
  local button = {}
  local metadata = {__index = ButtonClass}
  setmetatable(button, metadata)
  
  button.position = Vector(x, y)
  button.scale = 1
  if spriteClass ~= nil then
    button.sc = spriteClass
  else
    button.sc = nil
  end
  button.pressed = false
  
  return button
end

TurnButtonClass = ButtonClass:new()

function TurnButtonClass:new(x, y, spriteClass)
  local turnButton = {}
  local metadata = {__index = TurnButtonClass}
  setmetatable(turnButton, metadata)
  
  turnButton.scale = 0.5
  turnButton.position.x = x
  turnButton.position.y = y
  turnButton.sc = spriteClass
  
  return turnButton
end

function TurnButtonClass:test()
  print("test")
end

function TurnButtonClass:draw()
  xOffset = (BUTTON_SIZE.x*self.scale)/2 --6/11 7:09: fixed Nyx bug with dad, made start button and title screen functionality. However, there's a bug where the overlap check for a scaled button isn't correct, although for this button, not halving (BUTTON_SIZE.x*self.scale)/2 makes the overlap check correct - why?
  yOffset = (BUTTON_SIZE.y*self.scale)/2
  sprite = self.sc:getSprite(1)
  love.graphics.draw(sprite, self.position.x, self.position.y, 0, self.scale, self.scale, xOffset, yOffset)
  love.graphics.setFont(mainFont)
  love.graphics.print("End Turn", self.position.x, self.position.y, 0, self.scale, self.scale)
end

function TurnButtonClass:update(gameManager)
  --print(self.pressed)
  if gameManager.currentPhase == TURN_PHASE[1] and love.mouse.isDown(1) ~= true then --reset the button being pressed if it's the main phase - upon the button being pressed, the phase is set to end, so the button should only be able to be pressed once before submitCards() resolves. Edit: ok this doesn't really work, but adding in the extra conditions below (mainly, the currentPlayer check) does. Edit 2: adding in a check for if the mouse is released. Edit 2.5: forgot to put the 1 in the parentheses, that was why I was having problems
    self.pressed = false
    --print(self.pressed)
  end
  mousePos = Vector(love.mouse.getX(), love.mouse.getY())
  if detectOverlap((BUTTON_SIZE*self.scale), Vector(0,0), mousePos, self.position) and love.mouse.isDown(1) and self.pressed == false and gameManager.currentPhase == TURN_PHASE[1] and gameManager.currentPlayer == 1 then --This will need to be changed if multiplayer becomes a thing - best bet might be a combination of the currentPhase check at the start of update combined with a timer
    self.pressed = true --so that the button doesn't get pressed every frame the mouse is down
    self:press(gameManager)
  end
end

function TurnButtonClass:press(gameManager)
  gameManager:submitCards()
end


StartButtonClass = ButtonClass:new()
function StartButtonClass:new(x, y, spriteClass)
  local startButton = {}
  local metadata = {__index = StartButtonClass}
  setmetatable(startButton, metadata)
  
  startButton.scale = 1
  startButton.position.x = x
  startButton.position.y = y
  startButton.sc = spriteClass
  
  return startButton
end

function StartButtonClass:draw()
  xOffset = (BUTTON_SIZE.x*self.scale)/2
  yOffset = (BUTTON_SIZE.y*self.scale)/2
  sprite = self.sc:getSprite(1)
  love.graphics.draw(sprite, self.position.x, self.position.y, 0, self.scale, self.scale, xOffset, yOffset)
  love.graphics.setFont(mainFont)
  love.graphics.print("Start Game", self.position.x, self.position.y, 0, 1, 1, xOffset, yOffset) --why isn't offset needed?
end

function StartButtonClass:update()
  if love.mouse.isDown(1) ~= true then
    self.pressed = false
  end
  mousePos = Vector(love.mouse.getX(), love.mouse.getY())
  if detectOverlap((BUTTON_SIZE*self.scale), Vector(0,0), mousePos, self.position) and love.mouse.isDown(1) and self.pressed == false then
    self.pressed = true
    self:press()
  end
end
function StartButtonClass:press()
  gameStarted = true
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