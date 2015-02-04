import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tic_Tac_Total_Defeat extends PApplet {

/*
 * Tic Tac Total Defeat
 * (Jordan Arnesen, 2015 February 03)
 *  ---------------------------- 
 */

// VARIABLES
boolean debug = false;

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
public void setup() {
  size(500, 500);

  cellSize = (height - (2 * boardInset)) / 3;
  isGameSetup = false;
  isGameOver = false;
}

public void draw() {
  background(255);

  if (!isGameSetup) {
    setupGame();
  }
  drawBoard();
  showGameStatus();
}

// START OR RESET GAME
public void setupGame() {   
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
public void drawBoard() {
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

public void showGameStatus() {
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
public void placeMarkInCell(int cell) {
  if (cell > -1 && cell < 9) { 
    if (gameState[cell] == 0) { // cell not yet taken
      gameState[cell] = currentPlayer;
      isTurnTaken = true;
      turnsTaken++;

      if (turnsTaken > 4) { // no possible win unless player 1 has taken at least 3 turns
        gameOverCheck();
      }
      if (!isGameOver) endTurn();
    }
  }

  if (debug) {
    printArray(gameState);
  }
}

public void endTurn() {
  currentPlayer = currentPlayer * -1;
  isTurnTaken = false;
}

public void gameOverCheck() {
  // check possible winning combos
  if (gameState[4]*currentPlayer == 1) { 
    if ((gameState[0]*currentPlayer == 1 && gameState[8]*currentPlayer == 1) ||
      (gameState[1]*currentPlayer == 1 && gameState[7]*currentPlayer == 1) ||
      (gameState[2]*currentPlayer == 1 && gameState[6]*currentPlayer == 1) ||
      (gameState[3]*currentPlayer == 1 && gameState[5]*currentPlayer == 1)) {
      theWinner = currentPlayerString;
      isGameOver = true;
    }
  } 
  if (gameState[0]*currentPlayer == 1) {
    if ((gameState[1]*currentPlayer == 1 && gameState[2]*currentPlayer == 1) ||
      (gameState[3]*currentPlayer == 1 && gameState[6]*currentPlayer == 1)) {
      theWinner = currentPlayerString;
      isGameOver = true;
    }
  } 
  if (gameState[8]*currentPlayer == 1) {
    if ((gameState[2]*currentPlayer == 1 && gameState[5]*currentPlayer == 1) ||
      (gameState[6]*currentPlayer == 1 && gameState[7]*currentPlayer == 1)) {
      theWinner = currentPlayerString;
      isGameOver = true;
    }
  } 
  if (turnsTaken > 8) { // board full, tie game
    isGameOver = true;
  }
}

// PLAYER INPUTS
public void keyPressed() {
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
    } else {
      int cell = cellLetters.indexOf(key); 
      if (debug) println(cell);
      
      // -1 if key pressed was not in cellLetters
      if (cell > -1) placeMarkInCell(cell);
    }
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tic_Tac_Total_Defeat" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
