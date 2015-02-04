/*
 * Tic Tac Total Defeat
 * (Jordan Arnesen, 2015 February 03)
 *  ---------------------------- 
 */

// VARIABLES
boolean debug = true;

boolean isGameSetup;
float boardInset = 80;
float cellSize;
String cellLetters = "rtyfghvbn";

int[] gameState = new int[9];
boolean isGameOver;
String theWinner;

int currentPlayer;
String currentPlayerString;
int turnsTaken;
boolean isTurnTaken;

// MAIN FUNCTIONS
//______________________________________________________
void setup() {
  size(500, 500);

  cellSize = (height - (2 * boardInset)) / 3;
  isGameSetup = false;
  isGameOver = false;
}

void draw() {
  background(255);

  if (!isGameSetup) {
    setupGame();
  }
  drawBoard();
  showGameStatus();
  
//  if (currentPlayer < 0) { // AI is player O
//     takeTurnAI(); 
//  }
}

// START OR RESET GAME
//______________________________________________________
void setupGame() {   
  // set up array to store game state
  for (int i = 0; i < 9; i++) {
    gameState[i] = 0;
  }
  currentPlayer = 1;
  isTurnTaken = false;
  turnsTaken = 0;
  isGameSetup = true;
  isGameOver = false;
  theWinner = "Tie - no one";
}

// DISPLAY INFO
//______________________________________________________
void drawBoard() {
  // draw board
  int i = 0;
  for (int k = 0; k < 3; k++) {
    for (int j = 0; j < 3; j++) {

      // draw cell
      stroke(0);
      noFill();
      float xPos = boardInset + cellSize*j;
      float yPos = boardInset + cellSize*k;
      rect(xPos, yPos, cellSize, cellSize);

      //draw letter or player mark
      if (gameState[i] == 0) { 
        // cell not yet taken - show which key to claim it
        fill(0);
        textSize(20);
        textAlign(LEFT, TOP);
        text(cellLetters.substring(i, i+1).toUpperCase(), xPos + 5, yPos + 2);
      } else {
        // show the mark of player who claimed cell
        textSize(40);
        textAlign(CENTER, CENTER);
        if  (gameState[i] > 0) { // player X
          fill(255, 0, 0);
          text("X", xPos + cellSize/2, yPos + cellSize/2);
        } else { // player 0
          fill(0, 0, 255);
          text("O", xPos + cellSize/2, yPos + cellSize/2);
        }
      }
      i++;
    }
  }
}

void showGameStatus() {
  textSize(20);
  fill(0);
  textAlign(LEFT, TOP);

  if (isGameOver) {
    // show who won and game reset instructions
    text(theWinner+ " wins! To play again, press P.", 20, 15);
  } else {
    // show whose turn it is
    if (currentPlayer > 0) {
      currentPlayerString = "X";
    } else {
      currentPlayerString = "O";
    }
    if (!isTurnTaken) {
      text(currentPlayerString+"'s turn", 20, 15);
    } else {
      text("Press Spacebar to change players.", 20, 15);
    }
  }
}

// GAME LOGIC
//______________________________________________________
boolean placeMarkInCell(int cell) {
  if (cell > -1 && cell < 9) { 
    if (gameState[cell] == 0) { // cell not yet taken
      gameState[cell] = currentPlayer;
      isTurnTaken = true;
      turnsTaken++;

    }
  }

  if (debug) {
//    printArray(gameState);
  }
  return isTurnTaken; 
}

void endTurn() {
  if (turnsTaken > 4) { // no possible win unless player 1 has taken at least 3 turns
    gameOverCheck();
  }
  if (!isGameOver) {
    currentPlayer = currentPlayer * -1;
    isTurnTaken = false;
  }
}

void gameOverCheck() {
  if (madeWinningMove()) {
     theWinner = currentPlayerString;
     isGameOver = true;
  } else if (turnsTaken > 8 ) { // board full, tie game
      isGameOver = true;
  }
}

boolean madeWinningMove() {
  // check possible winning combos
  if (gameState[4]*currentPlayer == 1) { 
    if ((gameState[0]*currentPlayer == 1 && gameState[8]*currentPlayer == 1) ||
      (gameState[1]*currentPlayer == 1 && gameState[7]*currentPlayer == 1) ||
      (gameState[2]*currentPlayer == 1 && gameState[6]*currentPlayer == 1) ||
      (gameState[3]*currentPlayer == 1 && gameState[5]*currentPlayer == 1)) {
      return true;
    }
  } 
  if (gameState[0]*currentPlayer == 1) {
    if ((gameState[1]*currentPlayer == 1 && gameState[2]*currentPlayer == 1) ||
      (gameState[3]*currentPlayer == 1 && gameState[6]*currentPlayer == 1)) {
      return true;
    }
  } 
  if (gameState[8]*currentPlayer == 1) {
    if ((gameState[2]*currentPlayer == 1 && gameState[5]*currentPlayer == 1) ||
      (gameState[6]*currentPlayer == 1 && gameState[7]*currentPlayer == 1)) {
      return true;
    }
  }
  return false;
}

// PLAYER INPUTS
//______________________________________________________
void keyPressed() {
  if (isGameOver) {
    // can only start new game when prev game ends
    if (key == 'p') {
      setupGame();
    }
  } else if (isTurnTaken) {
    // can only change players if move already made
    if (key == ' ') {
      endTurn();
    }
  } else {
    // player must make a move
    if (key == 'q') { // for testing only
      isGameOver = true;
    } else if (key == 'a') { // for testing only
      takeTurnAI();
    } else {
      int cell = cellLetters.indexOf(key); 
      if (debug) println(cell);
      
      // -1 if key pressed was not in cellLetters
      if (cell > -1) placeMarkInCell(cell);
    }
  }
}

// AI LOGIC
//______________________________________________________
void takeTurnAI() {
  // completely random and awful AI implementation
   int cell = int(random(9));
   if (debug) println(cell);
   
   boolean success = placeMarkInCell(cell);
   if (debug) println(success);

   if (success) {
      endTurn(); 
   } else {
      takeTurnAI(); 
   }
}
