/**
 * Fast Poisson Disk Sampling in Arbitrary Dimensions 
 * a paper from Robert Bridson
 * https://docs.google.com/viewer?url=http%3A%2F%2Fwww.cs.ubc.ca%2F~rbridson%2Fdocs%2Fbridson-siggraph07-poissondisk.pdf
 * https://www.jasondavies.com/poisson-disc/
 * 
 * shifmman implementation
 + https://www.youtube.com/watch?v=flQgnCUxHlw
 */

//minimal distance between points
int r = 10;
int k = 30;
PVector grid [];
//square cell dimentions
float w = r / sqrt(2);

ArrayList<PVector> active = new ArrayList<PVector>() ; 

int cols, rows;

void setup() {
  size(500, 500);


  //STEP 0 from paper
  cols = floor(width/w);
  rows = floor(height/w);
  grid = new PVector [cols*rows]; 
  //fill the grid with -1 
  for (int i = 0; i < (cols*rows); i++) {
    grid[i]= new PVector (-1, -1) ;
  }

  //STEP 1 from paper
  float x = width/2;
  float y = height/2;
  int i = floor( x / w );
  int j = floor( y / w );
  PVector pos = new PVector (x, y );
  //ARRAYLIST -> add(int index, E element)
  //Inserts the specified element at the specified position in this list.
  grid[ i + (j*cols) ] = pos;
  active.add(pos);
}

void draw() {
  background(0);

  //STEP 2 from paper
  //the algoritm says to do a while loop
  // while (active.size()>0)
  //but we can use the draw loop 
  //and this way we can visualize the thing growing

  //try to find one in 25 tries
  //for (int total = 0; total < 25; total++) {
    if (active.size() > 0) {
      int  randIndex = floor (random ( active.size()) );
      //pick a point 
      PVector pos = active.get(randIndex); 

      boolean found = false;
      //pick a point that distances between r and 2r
      //from the last point obtain
      for (int n = 0; n < k; n++) {
        //float a = random(TWO_PI);
        //float offsetX = cos(a);
        //float offsetY = sin(a);
        //OR use pvector
        PVector sample = PVector.random2D();
        //make offset between r and 2r
        float mag = random(r, 2*r); 
        sample.setMag(mag);
        sample.add(pos);

        //CHECK PART
        //i only need to check the clossest points
        //in the cell grid wich gives me a performance boost
        //comparing to check all the points in the space
        int col = floor(sample.x / w);
        int row = floor(sample.y / w); 

        if (col > -1 && row > -1 && col < cols && row < rows 
          /*&& grid[col + row * cols].x != -1 
          && grid[col + row * cols].y != -1 */) {
          boolean ok = true;
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              //have to constrain because it keeps overflowing the array
              int index = constrain( ((col+i) + ( (row+j)*cols )), 0, (cols*rows)-1 ) ;
              println(index, col, row);
              
              PVector neighbor = grid[ index ];
              
              if ( neighbor.x != -1 && neighbor.y != -1 ) {
                float d = PVector.dist(sample, neighbor);
                if (d < r) {
                  ok = false;
                }
              }
            }
          }
          if (ok) {
            found = true;
            grid[ col + (row*cols) ] = sample;
            active.add(sample);
            //should we break
            //break;
          }
        }
      }
      if (!found) {
        active.remove(randIndex);
      }
    }
  //}

  for (int i = 0; i < grid.length; i++) {
    if (grid[i].x != -1 && grid[i].y != -1 ) {
      stroke(255);
      strokeWeight(4);
      point(grid[i].x, grid[i].y);
    }
  }

  for (int i = 0; i < active.size(); i++) {
    stroke(255, 0, 255);
    strokeWeight(4);
    point( active.get(i).x, active.get(i).y);
  }
}