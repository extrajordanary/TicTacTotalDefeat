/*
 * Tic Tac Total Defeat
 * (Jordan Arnesen, 2015 February 03)
 *  ---------------------------- 
 */
 
 // VARIABLES
 float boardInset = 50;
 float cellSize;
 
 // SETUP
 
 void setup() {
   size(500,500);
   
   cellSize = (height - (2 * boardInset)) / 3;
 }
   
 void draw() {
  background(255);
  
  setupBoard();
 }
 
void setupBoard() {
  
  // draw board
  stroke(0);
  for (int k = 0; k < 3; k++) {
    for (int j = 0; j < 3; j++) {
    rect(boardInset + cellSize*j, boardInset + cellSize*k, cellSize, cellSize);
    }
  }
   
  // set up array to store game state
 
}
