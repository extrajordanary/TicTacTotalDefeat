// AI LOGIC
//______________________________________________________
void takeTurnAI() {
  if (!isTurnTaken) {
    int cell = chooseBestCell(gameState, currentPlayer);
    if (debug) println("AI chooses cell "+cell);
  
    boolean success = placeMarkInCell(cell);
  
    if (success) {
      if (autoEndTurn) endTurn();
    } else { // logic error resulting in failed cell placement
      println("Error: AI logic fail.");
    }
  }
}

int chooseBestCell(int[] theGameState, int player) {
  // returns index of best cell's position in gameState array
  int bestCell;
  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);
  // get best outcomes for each available cell
  IntList bestOutcomes = getBestOutcomesArray(theGameState, player);
  // get the best of the outcomes from the IntList
  int bestOutcome = bestOutcomeInArray(bestOutcomes, player);

  // get index of cell with best outcome
  bestCell = openCells.get(0);
  for (int i = 0; i < bestOutcomes.size(); i ++) {
    if (bestOutcomes.get(i) == bestOutcome) {
      bestCell = openCells.get(i);
    }
  }

  return bestCell;
}

int getBestOutcome(int[] theGameState, int player) {
  // return value representing best game outcome for the player
  int bestOutcome;

  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);
  
  if (openCells.size() < 1) {
    // no moves to make, so must be a tie
    if (debug) println("getBestOutcome called on gameState with no open cells");
    bestOutcome = 0;
    
  } else if (openCells.size() == 1) {
    // if only one option, return value for win or tie
    int testCell = openCells.get(0);
    int[] newGameState = getPossibleGameState(theGameState, testCell, player);

    if (madeWinningMove(newGameState, player)) {
      bestOutcome = 10 * player;
    } else {
      bestOutcome = 0;
    }
    
  } else {
    // else, get best outcome for each possible move
    IntList bestOutcomes = getBestOutcomesArray(theGameState, player);
    
    // return the best of the outcomes
    bestOutcome = bestOutcomeInArray(bestOutcomes, player);
  }
  return bestOutcome;
}

IntList getBestOutcomesArray(int[] theGameState, int player) {
  IntList bestOutcomes = new IntList();
  IntList openCells = getOpenCells(theGameState);
  
  for (int i = 0; i < openCells.size(); i++) {
      // for each possible move, create newGameState
      int testCell = openCells.get(i);
      int[] newGameState = getPossibleGameState(theGameState, testCell, player);

      // check if newGameState is win condition
      int best;
      if (madeWinningMove(newGameState, player)) {
        // if win, set outcome value to add to array
        best = 1 * player;
      } else {
        // recursive call, passed to next player
        int nextPlayer = player * -1;
        best = getBestOutcome(newGameState, nextPlayer);
      }
      bestOutcomes.append(best);
    }
  return bestOutcomes;
}

int bestOutcomeInArray(IntList array, int player) {
  // return the best of the outcomes from the IntList
  if (player > 0) { // player X
    return array.max();
  } else {
    return array.min();
  }
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

int[] getPossibleGameState(int[] theGameState, int cell, int player) {
 // returns newGameState for player claiming cell
  int[] possGameState = new int[9];
  arrayCopy(theGameState, possGameState);
  possGameState[cell] = player;
  
  return possGameState;
}
