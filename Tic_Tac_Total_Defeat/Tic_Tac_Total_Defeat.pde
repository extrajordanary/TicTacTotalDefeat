/*
 * Tic Tac Total Defeat
 * (Jordan Arnesen, 2015 February 03)
 *  ---------------------------- 
 */

// VARIABLES
boolean debug = true;
boolean debugGameState = false;

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

int turnDelay = 1000; // in milliseconds
int turnStart;


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
  
//  if (!isGameOver && currentPlayer < 0) { // AI is player 'O'
//     if (millis() - turnStart > turnDelay) {
//       takeTurnAI(); 
//     }
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
  turnStart = millis();
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
  if (debug) println("Placing...");
  if (cell > -1 && cell < 9) { 
    if (gameState[cell] == 0) { // cell not yet taken
      gameState[cell] = currentPlayer;
      isTurnTaken = true;
      turnsTaken++;
    }
  }

  if (debugGameState) {
    printArray(gameState);
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
    turnStart = millis();
  }
}

void gameOverCheck() {
  if (madeWinningMove(gameState, currentPlayer)) {
     theWinner = currentPlayerString;
     isGameOver = true;
  } else if (turnsTaken > 8 ) { // board full, tie game
      isGameOver = true;
  }
}

boolean madeWinningMove(int[] theGameState, int player) {
  // check possible winning combos
  if (theGameState[4]*player == 1) { 
    if ((theGameState[0]*player == 1 && theGameState[8]*player == 1) ||
      (theGameState[1]*player == 1 && theGameState[7]*player == 1) ||
      (theGameState[2]*player == 1 && theGameState[6]*player == 1) ||
      (theGameState[3]*player == 1 && theGameState[5]*player == 1)) {
      return true;
    }
  } 
  if (theGameState[0]*player == 1) {
    if ((theGameState[1]*player == 1 && theGameState[2]*player == 1) ||
      (theGameState[3]*player == 1 && theGameState[6]*player == 1)) {
      return true;
    }
  } 
  if (theGameState[8]*player == 1) {
    if ((theGameState[2]*player == 1 && theGameState[5]*player == 1) ||
      (theGameState[6]*player == 1 && theGameState[7]*player == 1)) {
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
      if (debug) println("Human chooses cell "+cell);
      
      // -1 if key pressed was not in cellLetters
      if (cell > -1) {
        if (placeMarkInCell(cell)) endTurn();
      }
    }
  }
}

// AI LOGIC
//______________________________________________________
void takeTurnAI() {
   int cell = chooseCellAI();
   if (debug) println("AI chooses cell "+cell);
   
   boolean success = placeMarkInCell(cell);
   if (debug) println(success);

   if (success) { // should be able to remove once AI is smarter
      endTurn(); 
   } else {
//      takeTurnAI(); 
   }
}

int chooseCellAI() {  
  int cell = chooseBestCell(gameState, currentPlayer);
  return cell;
}

int chooseBestCell(int[] theGameState, int player) {
  // returns index of cell's position in gameState array
  
  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);
  
  // get array of best expected game outcomes
  
  // get index of best outcome
  
  // return cell number which produces best outcome
  
  if (debug) {
    println("Current state:");
    printArray(theGameState);
    printArray(openCells);
  }

  for (int i = 0; i < openCells.size(); i++) {
    int[] newGameState = new int[9];
    arrayCopy(theGameState, newGameState);
    int testCell = openCells.get(i);
    
    newGameState[testCell] = player;
    if (debug) {
      println("If AI takes cell "+testCell+"...");
      printArray(newGameState); 
    }
    if (madeWinningMove(newGameState, player)) {
       return testCell; 
    }
  }  
  return chooseFromOpenCells();
}

int getBestOutcome(int[] theGameState, int player) {
  // return value representing best game outcome for the player
  int bestOutcome;
  
  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);
  
  if (openCells.size() == 1) {
    // if only one option, return value for win or tie
    int[] newGameState = new int[9];
    arrayCopy(theGameState, newGameState);
    int testCell = openCells.get(0);
    newGameState[testCell] = player;
      
    if (madeWinningMove(newGameState,player)) {
      bestOutcome = 1 * player;
    } else {
      bestOutcome = 0;
    }
    return bestOutcome;
  
  } else {
  // else, get best outcome for each possible move and add values to IntList
    IntList bestOutcomes = new IntList();
    for (int i = 0; i < openCells.size(); i++) {
      // create newGameState
      int[] newGameState = new int[9];
      arrayCopy(theGameState, newGameState);
      int testCell = openCells.get(i);
      newGameState[testCell] = player;
      
      // check if newGameState is win condition
      int best;
      if (madeWinningMove(newGameState,player)) {
        // if win, set outcome value to add to array
        best = 1 * player;
      } else {
        // recursive call, passed to next player
        int nextPlayer = player * -1;
        best = getBestOutcome(newGameState,nextPlayer);
      }
      bestOutcomes.append(best); 
    }
    
    // return the best of the outcomes from the IntList
    if (player > 0) { // player X
      bestOutcome = max(bestOutcomes);
    } else {
      bestOutcome = min(bestOutcomes);
    }
    return bestOutcome;
  }

}

int chooseFromOpenCells() {
  IntList openCells = getOpenCells(gameState);
  openCells.shuffle();
  return openCells.get(0);
}

IntList getOpenCells(int[] theGameState) {
  IntList openCells = new IntList();
   for (int i = 0; i < theGameState.length; i++) {
      if (theGameState[i] == 0) {
        openCells.append(i);        
      }
   }
   if (debug) {
      println("Open cells: " + openCells.size()); 
   }
   return openCells;
}
