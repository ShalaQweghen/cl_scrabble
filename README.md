# Command-Line Scrabble

If you don't know how to play Scrabble, click [here](https://en.wikipedia.org/wiki/Scrabble) for rules

Clone the game and enjoy it. If you have any feedbacks, I will very much appreciate.

### Number of players

You can play the game as 2, 3, or 4 players.

### The starting square and the direction of a word

State the starting square of your word using the names of the columns and the rows: eg. h8, b12. When you state the starting square and the direction(right or down), the game will make a range for it. For example, we will place the word "money" starting the from the square "h8" to the right side. The game will make the range accordingly as "h8=M, i8=O, j8=N, k8=E, l8=Y". If one of the squares in the range of your word is occupied, as long as the occupying letter is the same as the letter corresponding that square in your word, your word will be placed on the board.

### Blank tile

When you have and want to use a blank tile(@), put it in place of the missing letter in your word (eg. You want to make "money" but you don't have a letter "n". If you have a blank tile(@), you can make your word like this: "mo@ey"). When you use a blank tile, you will be asked for what letter it is used for. Type the letter it substitutes.

### Multiple words

When you place your word on the board and make more than one word, you will get the points of those new word. You will only get the bonus squares if they are in the range of your new word. The interface will only display the word that was placed on the word but the points for the extra words will be added to your score.

### Saving the game

In order to save the game, press CTRL + C and the game will ask you if you want to save the game. If you want to save the game(y), you can enter a name for your save game. The game will create saves folder in the game root folder and in the saves file, a text file named as your save game. Next time you start the game, you will be asked if you want to load a saved game or start a new game. If you want to load a saved game(y), you can enter the name of the saved game and continue playing.