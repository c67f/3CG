GameManagerClass = {}

require "playerClass"
require "deckClass"
require "cardClass"
require "spriteClass"
require "CPUPlayerClass"
require "cardDataClass"

TURN_PHASE = { --currently doing phases separate from player turn, but could instead do my initial idea of a 2d table of [current player][phase]
    "main",
    "end"
}

HAND_SIZE = 7

WIN_THRESHOLD = 50

function GameManagerClass:new(player1, player2, locTable) --, spriteTable
  local gameManager = {}
  local metadata = {__index = GameManagerClass}
  setmetatable(gameManager, metadata)
  
  gameManager.p1 = player1
  gameManager.p2 = player2.playerObj
  gameManager.cpu = player2
  gameManager.locations = locTable
  --gameManager.sprites = spriteTable
  gameManager.currentPlayer = 1
  gameManager.currentPhase = TURN_PHASE[1]
  gameManager.currentRound = 1
  gameManager.winner = nil
  
  return gameManager
end

--gameManager:update, if cpu timer > x and turn is cpu's turn submitCards ?

function GameManagerClass:setupGame(decklist1, decklist2)
  
  deck1 = self.p1.deck
  deck2 = self.p2.deck
  print(decklist1)
  self:readDeck(decklist1, deck1, self.p1)--deck1 = 
  self:readDeck(decklist2, deck2, self.p2)--deck2 = 
  print(deck1.cards[1])
  
  cardDataBase = CardDataClass:new()
  
--  for i = 1, 40 do --fill player 1's deck with cards
--      --[1] is placeholder, eventually will need to correspond to a decklist - maybe store decklists as a series of numbers corresponding to indices of the different types of cards, and that number is used in sprites here and to get the effect?
--    table.insert(deck1.cards, card)
--    --print(#deck1.cards)
--  end
--  for i = 1, 40 do --fill player1's deck with cards
--    
--    table.insert(deck2.cards, card)
--  end
  
  self.p1.score = 0
  self.p2.score = 0
  --print(deck1.cards) --deck1.cards exists here,
  for i = 1, 5 do
    self.p1:drawCard(deck1.cards) --but not here? edit: forgot the colon instead of period, that's why
  end
  for i = 1, 5 do
    self.p2:drawCard(deck2.cards)
  end
  
  self.currentPhase = TURN_PHASE[1]
  
  self.p1.currMana = self.currentRound
  self.p2.currMana = self.currentRound -- since startTurn here only will set p1's mana
  self:startTurn()
end

function GameManagerClass:startTurn() --5/31: next thing is mana system and resetting mana on turn start, might need to refactor turn system?
  if self.currentPlayer == 1 then
    if #self.p1.hand < HAND_SIZE then
      self.p1:drawCard(self.p1.deck)
    end
    self.p1.currMana = self.currentRound
  else 
    if #self.p2.hand < HAND_SIZE then
      self.p2:drawCard(self.p1.deck)
    end
    self.p2.currMana = self.currentRound
  end
end


function GameManagerClass:submitCards()
  self.currentPhase = TURN_PHASE[2] --move to end phase
  if self.currentPlayer == 1 then
    self:nextTurn() --only reveal and score cards at the end of player 2's turn
  else
    --reveal all played cards of both players:
    self:revealAllCards() --last thing done 6/1 8:47: reveal cards function and cards having a revealed or unrevealed state, next thing is effects
    
    winner1 = 0
    winner2 = 0
    winner3 = 0
    winners = {winner1, winder2, winner3}
    score1 = 0
    score2 = 0
    score3 = 0
    scores = {score1, score2, score3}
    for _, loc in ipairs(self.locations) do
      if loc:getPowerDiff() > 0 then
        winners[_] = 1
        scores[_] = loc:getPowerDiff()
        print("player 1 scores " .. scores[_] .. " point at location " .. loc.num)
        self.p1.score = self.p1.score + scores[_] --this is kinda redundant but I'm keeping the separate scores variables for now just in case I want to use them later
      elseif loc:getPowerDiff() < 0 then
        winners[_] = 2
        scores[_] = loc:getPowerDiff() * -1 --diff is negative if player 2 wins
        print("player 2 scores " .. scores[_] .. " point at location " .. loc.num)
        self.p2.score = self.p2.score + scores[_]
      else
        winners[_] = 0
      end
    end
    --print(winners[1])
    --print(winners[2])
    --print(winners[3])
    
    --Check if either player has surpassed the score threshold to win:
    if self.p1.score >= WIN_THRESHOLD then
      self.winner = self.p1
      self:endGame() --oh neat I accidently made it not progress turns if you press the button but the game is over, since it never goes to nextTurn
    elseif self.p2.score >= WIN_THRESHOLD then
      self.winner = self.p2
      self:endGame()
    else
      self:nextTurn() --go to next player's turn
    end
  end
end

function GameManagerClass:endGame()
  print("the winner is player " .. self.winner.num .. "!")
end

function GameManagerClass:nextTurn()
  self.currentPhase = TURN_PHASE[1]
  if self.currentPlayer == 1 then
    self.currentPlayer = 2 --if it's player 2's turn, run the CPUPlayer
    self:startTurn()
    self.cpu:playCard(self.locations)
    self:submitCards() --submits cards, then goes to next turn, which will be player 1's turn
  else
    self.currentRound = self.currentRound + 1 --only increment the round at the end of player 2's turn
    print("player 1's turn")
    self.currentTurn = self.currentRound + 1 --increment current round after both players have gone
    self.currentPlayer = 1
    self:startTurn()
  end
end

function GameManagerClass:readDeck(deckList, deck, player)
  for _, cardId in ipairs(deckList) do
    --print(cardId)
    if cardId == 1 then
      --print("inserting " .. _ .. "th Wooden Cow")
      newCow = CowDataClass:new()
      --print(newCow)
      newCard = CardClass:new(250, 250, newCow, player)
      table.insert(deck.cards, newCard)
    elseif cardId == 2 then
      newPegasus = PegasusDataClass:new()
      newCard = CardClass:new(250, 250, newPegasus, player)
      table.insert(deck.cards, newCard)
    elseif cardId == 3 then
      newMinotaur = MinotaurDataClass:new()
      newCard = CardClass:new(250, 250, newMinotaur, player)
      table.insert(deck.cards, newCard)
    elseif cardId == 4 then
      newTitan = TitanDataClass:new()
      newCard = CardClass:new(250, 250, newTitan, player)
      table.insert(deck.cards, newCard)
    elseif cardId == 5 then
      newArtemis = ArtemisDataClass:new()
      newCard = CardClass:new(250, 250, newArtemis, player)
      table.insert(deck.cards, newCard)
    else
      print("error! unknown card id!")
    end
  end
  print(deck.cards[1])
  --return deck
end

function GameManagerClass:revealAllCards()
  for _, loc in ipairs(self.locations) do
    for _, card in ipairs(loc.p1Cards) do
      card.revealed = true
      if card.effect ~= nil then --if the card has an effect
        if card.effect.trigger == TRIGGER_IDS.REVEAL then --and if the card's effect is an "on reveal" effect
          card.effect:effect()
        end
      end
    end
    for _, card in ipairs(loc.p2Cards) do
      card.revealed = true
    end
  end
end