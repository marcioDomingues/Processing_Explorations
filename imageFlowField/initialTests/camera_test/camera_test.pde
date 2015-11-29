/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

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
    println("Available cameras:");
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
      color c =  color(0, 0, 255);
      //a.pixels[loc] = c;
      // a.pixels[loc] = cam.get( i, j );
      // a.pixels[loc] = cam.get( (i*a.width)/cam.width , (j*a.height)/cam.height );
      a.pixels[loc] = cam.get( i*cellsize, j*cellsize ); 
      //println( "a> " + i*cols/cam.width );
      //println( "a> " + a.width +" cam> " + cam.width + " = " +(cam.width/a.width) );
    }
  }
  a.updatePixels();

  // a.resize(100,0);
  //image(a, 0, 0, width, height);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, a);
  for ( int i = 0; i < cols; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {

      color c =  color( a.get( i, j ) ); 

      fill(c);
      //noStroke();
      rect(i*cellsize, j*cellsize, (i*cellsize)+cellsize, (j*cellsize)+cellsize);
    }
  }
}