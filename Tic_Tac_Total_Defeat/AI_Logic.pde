// AI LOGIC
//______________________________________________________
void takeTurnAI() {
  int cell = chooseBestCell(gameState, currentPlayer);
  if (debug) println("AI chooses cell "+cell);

  boolean success = placeMarkInCell(cell);
  if (debug) println(success);

  if (success) {
    endTurn();
  } else { // logic error resulting in failed cell placement
    println("Silly AI needs another try, press 'A'.");
  }
}

int chooseBestCell(int[] theGameState, int player) {
  // returns index of cell's position in gameState array

  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);

  // get array of best expected game outcomes
  IntList bestOutcomes = new IntList();
  for (int i = 0; i < openCells.size (); i++) {
    // create newGameState
    int[] newGameState = new int[9];
    arrayCopy(theGameState, newGameState);
    int testCell = openCells.get(i);
    newGameState[testCell] = player;

    // check if newGameState is win condition
    if (madeWinningMove(newGameState, player)) {
      // if win, return testCell
      return testCell;
    } else {
      // recursive call, passed to next player
      int nextPlayer = player * -1;
      int best = getBestOutcome(newGameState, nextPlayer);
      bestOutcomes.append(best);
    }
  }

  // return the best of the outcomes from the IntList
  int bestOutcome;
  if (player > 0) { // player X, positive 1
    bestOutcome = bestOutcomes.max();
  } else {
    bestOutcome = bestOutcomes.min();
  }

  // get index of best outcome
  int bestCell = openCells.get(0);
  for (int i = 0; i < bestOutcomes.size (); i ++) {
    if (bestOutcomes.get(i) == bestOutcome) {
      bestCell = openCells.get(i);
    }
  }

  // return cell number which produces best outcome
  return bestCell;
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

    if (madeWinningMove(newGameState, player)) {
      bestOutcome = 1 * player;
    } else {
      bestOutcome = 0;
    }
    return bestOutcome;
    
  } else {
    // else, get best outcome for each possible move and add values to IntList
    IntList bestOutcomes = getBestOutcomesArray(theGameState, player);
    
//    for (int i = 0; i < openCells.size(); i++) {
//      // create newGameState
//      int[] newGameState = new int[9];
//      arrayCopy(theGameState, newGameState);
//      int testCell = openCells.get(i);
//      newGameState[testCell] = player;
//
//      // check if newGameState is win condition
//      int best;
//      if (madeWinningMove(newGameState, player)) {
//        // if win, set outcome value to add to array
//        best = 1 * player;
//      } else {
//        // recursive call, passed to next player
//        int nextPlayer = player * -1;
//        best = getBestOutcome(newGameState, nextPlayer);
//      }
//      bestOutcomes.append(best);
//    }

    // return the best of the outcomes from the IntList
    if (player > 0) { // player X
      bestOutcome = bestOutcomes.max();
    } else {
      bestOutcome = bestOutcomes.min();
    }
    return bestOutcome;
  }
}

IntList getBestOutcomesArray(int[] theGameState, int player) {
  IntList bestOutcomes = new IntList();
  IntList openCells = getOpenCells(theGameState);
  
  for (int i = 0; i < openCells.size(); i++) {
      // for each possible move, create newGameState
      int[] newGameState = new int[9];
      arrayCopy(theGameState, newGameState);
      int testCell = openCells.get(i);
      newGameState[testCell] = player;

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

