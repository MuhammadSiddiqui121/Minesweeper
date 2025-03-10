import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for( int r = 0; r < NUM_ROWS;r++){
      for ( int c = 0; c < NUM_COLS; c++){
             buttons [r][c] = new MSButton(r,c);
      }
    }
    
    setMines();
}
public void setMines()
{
    //your code
    int mineCount =0;
      while( mineCount < NUM_ROWS + NUM_COLS){
    int randomRow = (int )(Math.random()*NUM_ROWS);
    int randomCol = (int )(Math.random()*NUM_COLS);
    if(! mines.contains( buttons[randomRow][randomCol])){
      mines.add(buttons[randomRow][randomCol]);
          mineCount++;
    }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  for(int r =0; r < NUM_ROWS; r++){
     for(int c = 0; c < NUM_COLS; c++){
      MSButton button = buttons[r][c];
      if(!mines.contains(button) && !button.clicked){ // if a non mine cell is still 
      //                                                 hidden then game is not won
       return false; 
      }
     }
    }

    
    return false;
}
public void displayLosingMessage()
{
   for (MSButton mine : mines) {
        mine.setLabel("L");  // Mark all mines with l
        mine.clicked = true;
    }

    // Display "Game Over" on all non-mine buttons
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c])) {
                buttons[r][c].setLabel("X");  // Mark non-mines with 'X'
            }
        }
    }

}
public void displayWinningMessage()
{
      for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel(":)");  // Winning smiley face
        }
    }
//your code here
}
public boolean isValid(int r, int c)
{
    //your code here
    if( r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
    return true;
  }
    return false;
}
public int countMines(int row, int col)
{
  
    int numMines = 0;
    //your code here
for( int r=- 1; r <= 1; r++){
         for( int c =  -1; c <=  1; c++ ){
           int newRow = NUM_ROWS + r;
           int newCol = NUM_COLS + c;
          if( ! ( r == 0  && c == 0)){
           if(isValid(newRow,newCol) && mines.contains(buttons[newRow][newCol])){
               numMines++;
               }
        }
          }
        }              
                      
       
  
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
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
        clicked = true;
        //your code here
        if( mouseButton == RIGHT){
         flagged = !flagged;
         if(!flagged){
           return ; 
         }
        }
        if( flagged){
          return;
        }
        clicked = true;
        if( mines.contains(this)){
         displayLosingMessage();
         return;
        }
        int numMines = countMines(myRow, myCol);
        if(numMines > 0){
         setLabel(numMines);  //shows neighbor mines #
        }
        else{
         for(int r = -1; r <=1; r++){
          for(int c = -1; c <=1; c++){
           int newRow = myRow + r;
           int newCol = myCol + c;
           if(isValid(newRow,newCol)){
            MSButton a = buttons[newRow][newCol];
            if(!a.clicked && !a.flagged){
             a.mousePressed(); //recursivley reveal
            }
           }
          }
         }
        }

    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
}
