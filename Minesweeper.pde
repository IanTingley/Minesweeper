import de.bezier.guido.*;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();; //ArrayList of just the minesweeper buttons that are mined
public final int NUM_ROWS = 20;
public final int NUM_COLS = 20;
public final int NUM_MINES = 20;

void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    buttons = new MSButton [NUM_ROWS][NUM_COLS];

    // make the manager
    Interactive.make( this );
    
    for(int a = 0; a<NUM_ROWS; a++){
      for(int b = 0; b<NUM_COLS; b++){
        buttons[a][b] = new MSButton(a,b);
      }
    }
    
    
    
    
    setMines();
}
public void setMines()
{
   while(mines.size() < NUM_MINES){
      int a = (int)(Math.random()*NUM_ROWS);
      int b = (int)(Math.random()*NUM_COLS);
      if(mines.contains(buttons[a][b]) == false){
        mines.add(buttons[a][b]);
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
    boolean KCR = true;
    for(int a = 0; a<mines.size(); a++){
      if(mines.get(a).isFlagged() == false){
        return false;
      }
    }        
    return true;
}
public void displayLosingMessage()
{
    for(int i = 0; i<mines.size(); i++){
      mines.get(i).setClicked();
    }
    fill(0);
    buttons[NUM_ROWS/2][NUM_COLS/3].setLabel("YOU");
    buttons[NUM_ROWS/2][2*NUM_COLS/3].setLabel("LOSE");

}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/3].setLabel("YOU");
    buttons[NUM_ROWS/2][2*NUM_COLS/3].setLabel("WIN");
}
public boolean isValid(int r, int c)
{
    if(r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int a = row-1; a<=row+1; a++){
      for(int b = col-1; b<=col+1; b++){
        if(isValid(a,b) && mines.contains(buttons[a][b])){
          numMines++;
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
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
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
        if (clicked) {
          
        } else if(mouseButton == RIGHT){
          if(flagged == false){
            flagged = true;
          }
          else if(flagged == true){
            flagged = false;
            clicked = false;
          }
        } else {
          clicked = true;
          if(mouseButton == LEFT && mines.contains(this)){
            displayLosingMessage();
          }
          else if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
          }
          else{
            for(int a = myRow-1; a<=myRow+1; a++){
              for(int b = myCol-1; b<=myCol+1; b++){
                if(isValid(a, b) == true && buttons[a][b].isFlagged() == false){
                  buttons[a][b].mousePressed();
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
        if(myLabel.equals("YOU") || myLabel.equals("LOSE") || myLabel.equals("WIN")){
          textSize(60);
          text(myLabel,x+width/2,(y+height/2)-40);
        }
        else{
          textSize(10);
          text(myLabel,x+width/2,y+height/2);
        }
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
    public void setClicked(){
      clicked = true;
    }
}
