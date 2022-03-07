import de.bezier.guido.*;
public static final int NUM_ROWS = 5;
public static final int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}
public void setMines()
{
  for (int i =0; i < 5; i++) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int won = 0;
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      if (buttons[r][c].clicked == true) {
        won ++;
      }
    }
  }
  if (won == NUM_COLS * NUM_ROWS - 5) {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      textSize(20);
      buttons[r][c].setLabel("Lost");
    }
  }
}
public void displayWinningMessage()
{
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++)
    {
      textSize(20);
      buttons[r][c].setLabel("Won");
    }
  }
}
public boolean isValid(int r, int c)
{
  if (r < 0 || r >= NUM_ROWS || c < 0 || c >= NUM_COLS) {
    return false;
  } else {
    return true;
  }
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = -1; r <= 1; r++) {
    for (int c = -1; c <= 1; c++) {
      if (isValid(row+r, col+c) && (!(r == 0 && c == 0)) && mines.contains(buttons[row + r][col + c])) {
        numMines ++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {

    if (mouseButton == RIGHT && clicked == false) {
      flagged = !flagged;
    } else {
      clicked = true;
      if (mines.contains(buttons[myRow][myCol])) {
        displayLosingMessage();
      } else if (countMines(myRow, myCol) ==0) {
        for (int r = -1; r <= 1; r++) {
          for (int c = -1; c <= 1; c++) {
            if ((!(r == 0 && c == 0))) {
              if (isValid(myRow+r, myCol +c) && (!(buttons[myRow + r][myCol + c].isClicked()))) {
                buttons[myRow + r][myCol + c].mousePressed();
              }
            }
          }
        }
      } else {
        setLabel(countMines(myRow, myCol));
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked() {
    return clicked;
  }
}
