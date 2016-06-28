//based on:
// Karl Sims -> http://www.karlsims.com/rd.html
// and
// shiffman -> https://www.youtube.com/watch?v=FYRINCEDVKI 
//

Cell[][] grid;
Cell[][] prev;


void setup()
{
  size (300,300);
  grid = new Cell [width][height];
  prev = new Cell [width][height];
  
  for ( int i = 0; i < width; i++ )
  {
    for ( int j = 0; j < width; j++ )
    {
      float a = 1;
      float b = 0;
      grid[i][j] = new Cell(a,b);
      prev[i][j] = new Cell(a,b);
      
    }
  }
  //populate world
  int seedWorld = 20;
  int seedSize = 2;

  populate ( seedWorld,  seedSize );
}  
  
  
  
  void populate (int seedWorld, int seedSize)
  {
    for ( int n = 0; n < seedWorld; n++ )
    {
      int startx = int(random(20, width-20));
      int starty = int(random(20, height-20));
      
      for ( int i = startx; i < startx + seedSize; i++ )
      {
        for ( int j = starty; j < starty + seedSize; j++ )
        {
          float a = 1;
          float b = 1;
          grid[i][j] = new Cell(a,b);
          prev[i][j] = new Cell(a,b);
        }
      }
    } 
  
  }
  
  

//good values for mesh
//dA = 0.99; dB = 0.4; float feed=0.0367, k=0.0649;
float dA = 1.0;
float dB = 0.5;
//test
//float feed=0.06, k=0.0649; 
//generic values
//float feed = 0.055;
//float k = 0.062;
//mitosis simulation 
//float feed=0.0367, k=0.0649; 
//coral growth simulation 
//float feed=0.0545, k=0.062;

//steady-state equilibrium concentrations
float feed=0.026, k=0.049;


void update()
{
  //skip corners
  for ( int i = 1; i < width-1; i++ )
  {
      for ( int j = 1; j < height-1; j++ )
      {
        
        Cell spot = prev[i][j];
        Cell newSpot = grid[i][j];
        
        float a = spot.a;
        float b = spot.b;
       
       //manually calculate the laplacian convolution
       //TODO 
       //openGL shade this bitch
        float laplaceA = 0;
        laplaceA += a*-1;
        laplaceA += prev[i+1][j].a*0.2;
        laplaceA += prev[i-1][j].a*0.2;
        laplaceA += prev[i][j+1].a*0.2;
        laplaceA += prev[i][j-1].a*0.2;
        laplaceA += prev[i-1][j-1].a*0.05;
        laplaceA += prev[i+1][j-1].a*0.05;
        laplaceA += prev[i-1][j+1].a*0.05;
        laplaceA += prev[i+1][j+1].a*0.05;
      
         float laplaceB = 0;
        laplaceB += b*-1;
        laplaceB += prev[i+1][j].b*0.2;
        laplaceB += prev[i-1][j].b*0.2;
        laplaceB += prev[i][j+1].b*0.2;
        laplaceB += prev[i][j-1].b*0.2;
        laplaceB += prev[i-1][j-1].b*0.05;
        laplaceB += prev[i+1][j-1].b*0.05;
        laplaceB += prev[i-1][j+1].b*0.05;
        laplaceB += prev[i+1][j+1].b*0.05;
  
        //formula from Karl Sims
        newSpot.a = a + (dA*laplaceA - a*b*b + feed*(1-a))*1;
        newSpot.b = b + (dB*laplaceB + a*b*b - (k+feed)*b)*1;
  
        newSpot.a = constrain(newSpot.a, 0, 1);
        newSpot.b = constrain(newSpot.b, 0, 1);
    
    }
  }
}

void swap() {
  Cell[][] temp = prev;
  prev = grid;
  grid = temp;
}

void draw() {
  println(frameRate);

  for (int i = 0; i < 1; i++) {
    update();
    swap();
  }

  //loadPixels();
  //for (int i = 1; i < width-1; i++) {
  //  for (int j = 1; j < height-1; j ++) {
  //    Cell spot = grid[i][j];
  //    float a = spot.a;
  //    float b = spot.b;
  //    int pos = i + j * width;
  //    pixels[pos] = color((a-b)*255);
  //  }
  //}
  //updatePixels();
  
  colorMode(HSB, 360, 100, 100);
  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * width;
      pixels[pos] = color((a-b)*360, 100, 100);
    }
  }
  updatePixels();
}


 