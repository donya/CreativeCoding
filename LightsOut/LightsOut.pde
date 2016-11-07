/*
Lights Out Game with Sound
Donya Quick

Based on the portable game by Tiger Electronics.

Music: "Find a Weapon!" by Donya Quick (find_a_weapon.wav)
*/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


int rows = 6;
int cols = 5;
float squareSize = 100;
Square[][] board = new Square[rows][cols];
boolean printTrace = false; // for debugging
int moves = 3;
boolean win = false;
String winText = "You win!"+
  "\nPress space to play again.\n"+
  "Press 1-9 to change difficulty.";
  
String startText = "Press space to start.\n\nDefault difficulty is 3.\n\n" +
  "Press 1-9 to change difficulty.\n\n"+
  "Press space any time to give\nup and try another game.";
boolean started = false;
AudioPlayer player;
AudioPlayer player2;
AudioPlayer player3;
Minim minim;

void setup() {
  size(500,600);
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      board[i][j] = new Square(squareSize);
      board[i][j].setLocation(j*squareSize, i*squareSize);
    }
  }
  randomSetup(moves);
  minim = new Minim(this);
  player = minim.loadFile("find_a_weapon.mp3");
  player2 = minim.loadFile("explosion2.mp3");
  player3 = minim.loadFile("boo.mp3");
  player.loop();
}

void draw() {
  if (started) { // did the user enter the first game yet?
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        board[i][j].drawSquare();
      }
    }
    if (!win) { // did the user win?
      checkWin();
    } else { // user did not win, so draw the current board
      fill(255,0,0);
      textSize(30);
      text(winText, 30, 50);
    }
  } else { // game not started yet - draw initial text
    background(0);
    fill(255,0,0);
    textSize(30);
    text(startText, 30, 50);
  }
}

/* Activates cells around the one pressed by the user */
void pressNeighbors(int i, int j, boolean fade) {
  if (i>0) {
    board[i-1][j].press(fade);
  }
  if (i<rows-1) {
    board[i+1][j].press(fade);
  }
  if (j>0) {
    board[i][j-1].press(fade);
  }
  if (j<cols-1) {
    board[i][j+1].press(fade);
  }
}

/* Handle mouse events */
void mousePressed() {
  if (started && !win) {
    int i = 0;
    boolean found = false;
    while (i<rows && !found) { // keep going until we find the mouse
      int j = 0;
      while (j<cols && !found) { // keep going until we find the mouse
        if (board[i][j].overSquare(mouseX,mouseY)) {
          board[i][j].press();
          pressNeighbors(i,j,false);
          found = true;
        }
        j++;
      }
      i++;
    }
  }
}

/* Generates a new game that is guaranteed to be solvable */
void randomSetup(int repetitions) {
  for (int i=0; i<repetitions; i++) {
    int rRow = round(random(0,rows-1));
    int rCol = round(random(0,cols-1));
    board[rRow][rCol].press(true);
    pressNeighbors(rRow, rCol,true);
    if (printTrace) {
      println(rRow+ "\t" +rCol);
    }
  }
}

/* Handle keyboard input */
void keyPressed() {
  if (key==' ') { // start a new game?
    if (started) { // did we start the first game?
      if (!win) { // did the player quit a game without winning?
        player3.rewind(); // reset the "booo" sound
        player3.play(); // play the "booo" sound
      }
    } else {
      started = true;
    }
    newGame(); // generate a new game to play
  } else
  if (key >= '1' && key <='9') { // user selecting a difficulty
    if (!started) {
      started = true;
    }
    moves = int(key)-int('0'); // number of moves = number key pressed
    newGame(); // generate a new game to play
  }
}

/* Generate a new game */
void newGame() {
  // first, we need to clear the board (turn everything off)
  for (int i=0; i<rows; i++) {
    for (int j =0; j<cols; j++) {
      board[i][j].off();
    }
  }
  win = false; // reset win state
  randomSetup(moves); // build a random game to solve
}

/* Determine whether the board represents a win state 
A win state exists if there are no lights turned on. */
void checkWin() {
  if (!win) { // only check for a win if we know we didn't win
    int i = 0;
    boolean found = false;
    while (i<rows && !found) {
      int j = 0;
      while (j<cols && !found) {
        if (board[i][j].isOn()) {
          found = true; // found a light on, so no win
        }
        j++;
      }
      i++;
    }
    if (!win && !found) { // win state?
      player2.rewind(); // reset win sound
      player2.play(); // play win sound
    }
    if (!found) { // set win flag
      win = true;
    }
  }
}