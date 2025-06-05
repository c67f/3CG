Programming Patterns:
-Subclass Sandbox for card effects and data classes
-Game Loop in gameManager
-Update Method in update



Assets:
all were made by me via LOVE2D's built in graphic functions, with the exception of the card sprite, which was made by me in Piskel

Postmortem:
It took a bit to figure out, but I think the way I ended up implementing the cards and their effects and data, imitating the Zelda game we've worked on in class, works well. I think my gameManager is a little awkward, though - each turn step is a different function but there's no central game loop function, so it's kind of opaque or unintuitive.