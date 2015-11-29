/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */
boolean debug = true;
boolean parallel = false;

import processing.video.*;

Capture cam;


PImage a ;

int cellsize = 8; // Dimensions of each cell in the grid
int cols, rows;   // Number of columns and rows in our system


void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    //println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, 640, 480, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }


  cols = cam.width/cellsize;             // Calculate # of columns
  rows = cam.height/cellsize;            // Calculate # of rows

  a = createImage(cols, rows, RGB);



  a.loadPixels();
  for ( int i = 0; i < cols; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {
      //int x = i*cellsize + cellsize/2; // x position
      //int y = j*cellsize + cellsize/2; // y position
      int loc = i + j * (a.width);           // Pixel array location
      //color c =  color(0, 0, 255);
      //a.pixels[loc] = c;
      // a.pixels[loc] = cam.get( i, j );
      // a.pixels[loc] = cam.get( (i*a.width)/cam.width , (j*a.height)/cam.height );
      a.pixels[loc] = cam.get( i*cellsize, j*cellsize );
    }
  }

  a.filter(BLUR, 1);

  a.updatePixels();

  // a.resize(100,0);
  //image(a, 0, 0, width, height);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, a);
  if ( debug ) {
    for ( int i = 0; i < cols; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {

        color c =  ( a.get( i, j ) ); 
        //println(c);
        fill(c);
        noStroke();

        rect(i*cellsize, j*cellsize, (i*cellsize)+cellsize, (j*cellsize)+cellsize);
      }
    }
  } else {
    background(0);
  }

  //deixar espaco nas primeiras e ultimas linhas de pixeis
  for ( int i = 1; i < cols-1; i++) {
    for ( int j = 1; j < rows-1; j++) {
      //now working with a 2 dim array
      //pointWhereIAM
      //int pos    = a.get( i, j );
      //   ---------|  yPosUp   |----------          
      //   xPosBack |    pos    | xPosFront
      //   ---------|  yPosDown |----------           
      //float xPosFront =  norm(  brightness(a.get( i+1, j )),  0, 255);
      //float xPosBack  =  norm(  brightness(a.get( i-1, j )),  0, 255);

      float xPosFront =  brightness(a.get( i+1, j )) / 50;
      float xPosBack  =  brightness(a.get( i-1, j )) / 50;
      float xDiff = xPosFront - xPosBack;

      float yPosUp   = brightness(a.get( i, j+1 )) / 50;
      float yPosDown = brightness(a.get( i, j-1 )) / 50;
      float yDiff = yPosUp - yPosDown;


      PVector forceDirc = new PVector(xDiff, yDiff);
      // forceDirc.set(vXDiff);
      // forceDirc.add(vYDiff);
      //println(forceDirc);
      //forceDirc.setMag(20);
      //forceDirc.normalize();
      forceDirc.mult(10);

      PVector v = new PVector(0, 0, 1);
      PVector forceDircP = forceDirc.cross(v);


      if (!parallel) {
        stroke(255, 255, 255, 255);
        line( i*cellsize+(cellsize/2), 
          j*cellsize+(cellsize/2), 
          (i*cellsize+(cellsize/2))+ forceDirc.x, 
          (j*cellsize+(cellsize/2))+ forceDirc.y 
          );
      } else {
        stroke(0, 255, 0, 255);
        line( i*cellsize+(cellsize/2), 
          j*cellsize+(cellsize/2), 
          (i*cellsize+(cellsize/2))+ forceDircP.x, 
          (j*cellsize+(cellsize/2))+ forceDircP.y 
          );
      }
      //fill(c);
      //noStroke();
      //rect(i*cellsize, j*cellsize, (i*cellsize)+cellsize, (j*cellsize)+cellsize);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }

  if (key == 'p') {
    parallel = !parallel;
    //debug = !debug;
  }
}