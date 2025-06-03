SpriteClass = {}
function SpriteClass:new()
  local sprite = {}
  local metadata = {__index = SpriteClass}
  setmetatable(sprite, metadata)
  
  sprite.sprites = { 
      love.graphics.newImage("Images/CardTemplate.png"),
      love.graphics.newImage("Images/CardBack.png")
  }
  
  return sprite
end

function SpriteClass:getSprite(index) --
  --print(#self.sprites)
  return self.sprites[index] --currently sprites don't need to be a table, but it's there for potentially future animated sprites. right now the sprite for anything will always be the first one in the table since there will only be one in the table
end

SpriteClassCardTemplate = SpriteClass:new()

SpriteClassButton = SpriteClass:new()


function SpriteClassButton:new()
  self.sprites = {
    love.graphics.newImage("Images/ButtonTemplate.png")
  }
  return self
end