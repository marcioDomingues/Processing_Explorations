
//TODO
//-> a double constructor one for stills and other for video
class Field {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  // perpendicularField is the cross product of the flowfield 
  PVector[][] perpendicularField;

  int cols, rows;   // Number of columns and rows in our system
  int resolution = 10; // Dimensions of each cell in the grid

  int wF, hF;

  int [][] base; 

  int vectorIntencity=100;
  int vectorMultiplier=10;


  Field( int w, int h, int resolution ) {
    this.wF = w;
    this.hF = h;
    this.resolution = resolution;
    // Determine the number of columns and rows based on sketch's width and height
    this.cols = wF/resolution;
    this.rows = hF/resolution;

    init();
  }

  void init() {

    base = base = new color[cols][rows]; 

    field = new PVector[cols][rows];
    perpendicularField = new PVector[cols][rows];
  }


  void update( PImage capture ) {

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {  
        //Pixel array location in the image  
        //int loc = i + j * (cols);
        //get grayscale image pixels at location to int[]
        base[i][j] = ( capture.get( i*resolution, j*resolution ) );
        //B&W
        //base[loc] = (int)brightness( capture.get( i*resolution, j*resolution ) );
      }
    }


    for ( int i = 1; i < cols-1; i++) {
      for ( int j = 1; j < rows-1; j++) {       
        //Now the Vectors
        //atention we cannot calculate at margin pixles
        //so have to check if in the border
        //if ( !(i==0 || i==(cols-1) || j==0 || j==(rows-1)) ) {
        //now working with a 2 dim array
        //pointWhereIAM
        //int pos    = base[i][j];
        //   ---------|  yPosUp   |----------          
        //   xPosBack |    pos    | xPosFront
        //   ---------|  yPosDown |----------   
        float xPosFront = brightness( base[i+1][j] )/50;
        float xPosBack  = brightness( base[i-1][j] )/50;
        float xDiff = xPosFront - xPosBack;
        //println("xdiff= " + xDiff + " x-1 " + xPosBack + " x+1 " + xPosFront);

        PVector xf = new PVector (xPosFront, 0);
        PVector xb = new PVector (-xPosBack, 0);
        PVector xs = xf.add(xf, xb);
        //println("xVdiff= " + xs + " V.x-1 " + xb + " V.x+1 " + xf);

        float yPosUp   = brightness( base[i][j+1] ) / 50;
        float yPosDown = brightness( base[i][j-1] ) / 50;
        float yDiff = yPosUp - yPosDown;
        //println("ydiff= " + yDiff + " y-1 " + yPosDown + " y+1 " + yPosUp);

        PVector yf = new PVector (0, yPosUp);
        PVector yb = new PVector (0, -yPosDown);
        PVector ys = yf.add(yf, yb);
        //println("yVdiff= " + ys + " V.y-1 " + yb + " V.y+1 " + yf);



        PVector forceDirc = xs.add(xs, ys);

        //println(forceDirc);
        //forceDirc.normalize();
        field[i][j] = forceDirc ;

        //perpendicular vector
        PVector v = new PVector(0, 0, 1);
        PVector forceDircperpendicular = forceDirc.cross(v);

        perpendicularField[i][j]= forceDircperpendicular;
      }
    }
  }

  // Draw every vector
  //send string "RGB" for color debug
  void displayPixelField( String rgb ) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {

        int argb = base[i][j];

        if (rgb == "RGB") {
          // Using "right shift" as a faster technique than red(), green(), and blue()
          int a = (argb >> 24) & 0xFF;
          int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
          int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
          int b = argb & 0xFF;          // Faster way of getting blue(argb)
          fill(r, g, b, a);
        } else {
          int a = (argb >> 24) & 0xFF;
          int r = (argb >> 16) & 0xFF;  
          fill(r, a);
        }       
        noStroke();
        rect(i*resolution, j*resolution, (i*resolution)+resolution, (j*resolution)+resolution);
      }
    }
  }

  // Draw every vector
  void displayField() {
    for (int i = 1; i < cols-1; i++) {
      for (int j = 1; j < rows-1; j++) {

        drawVector(field[i][j], 
        i*resolution, 
        j*resolution, 
        vectorMultiplier, 
        color(255, 0, 0, vectorIntencity));
      }
    }
  }

  void displayPerpendicularField() {
    for (int i = 1; i < cols-1; i++) {
      for (int j = 1; j < rows-1; j++) {

        drawVector(perpendicularField[i][j], 
        i*resolution, 
        j*resolution, 
        vectorMultiplier, 
        color(0, 255, 0, vectorIntencity));
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl, color vectorColor) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x, y);
    stroke(vectorColor);
    // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }
}

