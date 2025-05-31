GameManagerClass = {}

require "playerClass"
require "deckClass"
require "cardClass"
require "spriteClass"

function GameManagerClass:new()
  local gameManager = {}
  local metadata = {__index = GameManagerClass}
  setmetatable(gameManager, metadata)
  
  
  return gameManager
end

function GameManagerClass:setupGame(player1, player2, sprite)
  deck1 = player1.deck
  deck2 = player2.deck
  
  for i = 1, 40 do --fill player 1's deck with cards
    card = CardClass:new(250, 250, 1, 1, nil, sprite, player1)
    table.insert(deck1.cards, card)
    --print(#deck1.cards)
  end
  for i = 1, 40 do --fill player1's deck with cards
    card = CardClass:new(250, 250, 1, 1, nil, sprite, player2)
    table.insert(deck2.cards, card)
  end
  
  player1.score = 0
  player2.score = 0
  --print(deck1.cards) --deck1.cards exists here,
  for i = 1, 5 do
    player1:drawCard(deck1.cards) --but not here? edit: forgot the colon instead of period, that's why
  end
  for i = 1, 5 do
    player2:drawCard(deck2.cards)
  end
end

function GameManagerClass:SubmitCards(player1, player2, locations)
  winner1 = 0
  winner2 = 0
  winner3 = 0
  winners = {winner1, winnder2, winner3}
  score1 = 0
  score2 = 0
  score3 = 0
  scores = {score1, score2, score3}
  for _, loc in ipairs(locations) do
    if loc:getPowerDiff() > 0 then
      winners[_] = 1
      scores[_] = loc.getPowerDiff()
      player1.score = player1.score + scores[_] --this is kinda redundant but I'm keeping the separate scores variables for now just in case I want to use them later
    elseif loc:getPowerDiff() < 0 then
      winners[_] = 2
      scores[_] = loc.getPowerDiff() * -1 --diff is negative if player 2 wins
      player2.score = player2.score + scores[_]
    else
      winners[_] = 0
    end
  end
end