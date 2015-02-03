/*
 * Tic Tac Total Defeat
 * (Jordan Arnesen, 2015 February 03)
 *  ---------------------------- 
 */
 
 // VARIABLES
boolean debug = true;

boolean isBoardSetup = false;
float boardInset = 50;
float cellSize;
 
int[] gameState = new int[9];
String[] cellLetters = {"R", "T", "Y", "F", "G", "H", "V", "B", "N"};
 
 // SETUP
 
 void setup() {
   size(500,500);
   
   cellSize = (height - (2 * boardInset)) / 3;
 }
   
 void draw() {
  background(255);
  
  if (!isBoardSetup) {
    setupBoard();
  }
  drawBoard();
  
  if (debug) {
    showGameState();
 }
}
 
void setupBoard() {   
  // set up array to store game state
 for (int i = 0; i < 9; i++) {
   gameState[i] = 0;
 }
 isBoardSetup = true;
}

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
      //draw letter
      textSize(14);
      fill(0);
      textAlign(LEFT, TOP);
      text(cellLetters[i], xPos + 5, yPos);
      i++;
    }
  }
}

void showGameState() {
  textSize(20);
  fill(0);
  textAlign(LEFT, TOP);
  text("Player: "+"1", 20, 15);
//  printArray(gameState);
}
