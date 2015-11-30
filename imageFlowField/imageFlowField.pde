/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */


boolean debug = false;

//cam imports
import processing.video.*;
//Gui imports
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;


Capture cam; 

private ControlP5 cp5;
ControlFrame cf;
//p5 slider variables instances


boolean parallel = true;
boolean vector = true;
boolean backgroundImage = true;

float blurAmout = 1.0;

int vectorIntencity;
int vectorMultiplier;

float v = 1.0 / 9.0;
float[][] kernel = {{ v, v, v }, 
                    { v, v, v }, 
                    { v, v, v }};


PImage a, imgCopy;

int cellsize = 8; // Dimensions of each cell in the grid
int cols, rows;   // Number of columns and rows in our system


void setup() {
  size(640, 480, P2D);


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
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    //cam = new Capture(this, cameras[4]);
    // Or, the settings can be defined based on the text in the list
    cam = new Capture(this, 640, 480, "FaceTime HD Camera", 30);

    // Start capturing the images from the camera
    cam.start();
  }  

  cp5 = new ControlP5(this);

  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("Control Panel", 200, 200);
  // add Controllers to the 'extra' Frame inside 
  // the ControlFrame class setup() method below.
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }


  cols = cam.width/cellsize;             // Calculate # of columns
  rows = cam.height/cellsize;            // Calculate # of rows



  a = createImage(cols, rows, RGB);
  //imgCopy = createImage(cols, rows, RGB);


  a.loadPixels();
  for ( int i = 0; i < cols; i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows; j++) {
      //int x = i*cellsize + cellsize/2; // x position
      //int y = j*cellsize + cellsize/2; // y position
      int loc = i + j * (a.width);           // Pixel array location
       //int c =  (int)brightness(cam.get( i*cellsize, j*cellsize ));
      //a.pixels[loc] = c;
      // a.pixels[loc] = cam.get( i, j );
      // a.pixels[loc] = cam.get( (i*a.width)/cam.width , (j*a.height)/cam.height );
      a.pixels[loc] = cam.get( i*cellsize, j*cellsize );
    }
  }
  a.updatePixels();


 //a = makeBlur(a, imgCopy);
  a.filter(BLUR, blurAmout);




  if ( backgroundImage ) {
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
      forceDirc.mult(vectorMultiplier);

      PVector v = new PVector(0, 0, 1);
      PVector forceDircParallel = forceDirc.cross(v);


      if (vector) {
        stroke(255, 255, 255, vectorIntencity);
        line( i*cellsize+(cellsize/2), 
        j*cellsize+(cellsize/2), 
        (i*cellsize+(cellsize/2))+ forceDirc.x, 
        (j*cellsize+(cellsize/2))+ forceDirc.y 
          );
      } 
      if (parallel) {
        stroke(0, 255, 0, vectorIntencity);
        line( i*cellsize+(cellsize/2), 
        j*cellsize+(cellsize/2), 
        (i*cellsize+(cellsize/2))+ forceDircParallel.x, 
        (j*cellsize+(cellsize/2))+ forceDircParallel.y 
          );
      }
      //fill(c);
      //noStroke();
      //rect(i*cellsize, j*cellsize, (i*cellsize)+cellsize, (j*cellsize)+cellsize);
    }
  }
}

//void keyPressed() {
//  if (key == ' ') {
//    debug = !debug;
//  }
//  if (key == 'p') {
//    parallel = !parallel;
//    //debug = !debug;
//  }
//   if (key == 'v') {
//    vector = !vector;
//    //debug = !debug;
//  }
//}
void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }

}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}





PImage makeBlur(PImage imgIn, PImage imgOut) { 
  
  imgIn.loadPixels();

 

  // Loop through every pixel in the image
  for (int y = 1; y < imgIn.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < imgIn.width-1; x++) {  // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*imgIn.width + (x + kx);
          // Image is grayscale, red/green/blue are identical
          float val = red(imgIn.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      imgOut.pixels[y*imgIn.width + x] = color(sum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  imgIn.updatePixels();
  
 return imgOut;
}



