/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;

Capture cam;



boolean asLine= false;
PVector horizontalScanline;
PVector verticalScanline;
//array for scanLine
int[] horizontalScanValues;
int[] verticalScanValues;

void setup() {
  size(960, 480);
  background(20);

  colorMode(RGB);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  cam = new Capture(this, width/3, height/2);

  horizontalScanValues = new int[cam.width];
  verticalScanValues = new int[cam.height];
  // Start capturing the images from the camera
  cam.start();
}

void draw() {
  background(20);

  if (cam.available() == true) {
    cam.read();
    // convert to grey scale
    cam.loadPixels();

    for (int i = 0; i < cam.pixels.length; i++) {
      // Pick a random number, 0 to 255
      //float rand = random(255);
      // Create a grayscale color based on random number
      //color c = color(rand);
      // Set pixel at that location to random color
      cam.pixels[i] = color( grey( cam.pixels[i] ) );
    }
    // Reversing x to mirror the image
    /*
    // Begin loop for columns
     for (int i = 0; i < width; i++) {
     // Begin loop for rows
     for (int j = 0; j < height; j++) {
     
     // Where are we, pixel-wise?
     int x = i;
     int y = j;
     int loc = (cam.width - x - 1) + y*cam.width; // Reversing x to mirror the image
     }
     }  
     */
    cam.updatePixels();
  }



  image(cam, 0, 0, 320, 240);


  //check if the is a line selected
  if (asLine == true) {
    stroke(255, 0, 0);
    //draw  horizontal scan line
    line( 0, horizontalScanline.y, (width/3)-1, horizontalScanline.y);
   
    stroke(0, 255, 0);
    //draw vertical scan line
    line( verticalScanline.x, 0, verticalScanline.x, (height/2)-1);
    
    //draw graph of values in horizontal scanline
    color red = #FF0000;
    drawLineInt( width/3 + 20, 0, width/3, height/2, horizontalScanValues, red );
 
   //draw graph of values in vertical scanline
   color green = #00FF00;
    drawLineInt( 2*(width/3) + 60, 0, (height/2), height/2, verticalScanValues, green );
  }
}


//draw line intensities 
void drawLineInt( int x0, int y0, int boxWidth, int boxHeight, int[] values, color c ) {
  //draw graph
  stroke(c);
  int originX = x0;
  int originY = y0 + (boxHeight-21);

  for (int x=0; x < values.length-1; x++) {
    int mapedValues0 = (int)map(values[x], 0, 255, 0, (boxHeight-21));
    int mapedValues1 = (int)map(values[x+1], 0, 255, 0, (boxHeight-21));
    //point( originX+x, originY-mapedValues );
    
    //draw scan line with image line gradient
    //stroke( values[x] );
    line( originX+x, originY-mapedValues0, (originX+x+1), originY-mapedValues1);
  }

  //graph box
  stroke(255);
  noFill();
  rect(x0, y0, boxWidth-1, boxHeight-21);


  //draw gradient
  for (int x=0; x < values.length; x++) {
    stroke(values[x]);
    line( originX+x, (y0+boxHeight-21), originX+x, (y0+boxHeight)-2 );
  }
  //gradient box
  stroke(255);
  noFill();
  rect(x0, (y0+boxHeight-21), boxWidth-1, 20 );
}


void mouseMoved() {
  if ( mouseX > 0 && mouseX < width/2 && mouseY > 0 && mouseY < height/2 ) {
    //horizontal line
    stroke(255, 0, 0, 100);
    line( 0, mouseY, (width/3)-1, mouseY);
    //vertical line
    stroke(0, 255, 0, 100);
    line( mouseX, 0, mouseX, (height/2)-1);

  }
}

void mouseClicked() {
  if ( mouseX > 0 && mouseX < width/2 && mouseY > 0 && mouseY < height/2 ) {
    asLine = true;
    horizontalScanline = new PVector(mouseX, mouseY);
    verticalScanline = new PVector(mouseX, mouseY);

    //correr todas as colunas na linha selecionada
    for ( int x=0; x<cam.width; x++) {
      int loc = x + (mouseY*cam.width);
      int b = (int)brightness(cam.pixels[loc]);
      horizontalScanValues[x]=b;
    }
    
      //correr todas as linhas na coluna selecionada
    for ( int y=0; y<cam.height; y++) {
      //scan values in vertical line and get values 
      //from cam array
      int loc = (y * cam.width) + mouseX;
      //println(mouseX);
      int b = (int)brightness(cam.pixels[loc]);
      verticalScanValues[y]=b;
    }
    
    convertToSound( horizontalScanValues );
  }
}


//convert to grayscale
int grey(color p) {
  return max((p >> 16) & 0xff, (p >> 8) & 0xff, p & 0xff);
}


//convert to sound
//dc offset removal
void convertToSound( int[] brightnessValues ) {

  int grabW = cam.width;//Width of the camera frame
   
  int sampleRate = 44100;//Sample rate of sound
  float duration = 0.25;//Duration of the recorded
  //sound in seconds
  int N = (int)(duration * sampleRate);  //Size of the PCM buffer

  float[] buffer = new float[N]; //PCM buffer of sound sample
  int playPos = 0; //The current position of the buffer playing

  float[] arr = new float[brightnessValues.length];

  //Read central line's pixels brightness to arr
  for (int i=0; i<arr.length; i++) {  
    arr[i] = map( brightnessValues[i], 0, 255, -1, 1 );
  }

  //Stretch arr to buffer, using linear interpolation
  for (int i=0; i<N; i++) {
    //Get position in range [0, grabW]
    //float pos = float(i) * grabW / N;
    //but grabW is the size of my array with values
    float pos = float(i) * ((brightnessValues.length) / N);
    //Get left and right indices
    int pos0 = int( pos );
    int pos1 = min( pos0 + 1, N-1 );
    //Interpolate
    buffer[i] = map( pos, pos0, pos1, arr[pos0], arr[pos1]);
  }


for (int i=0; i<arr.length; i++) {
    //println(arr[i]);
  }
//println("size of arrays> arr_"+arr.length + " N_"+ N +" buffer_"+buffer.length);



  //DC-offset removal
  //Compute a mean value of buffer
  float mean = 0;
  for (int i=0; i<N; i++) {
    mean += buffer[i];
  }
  mean /= N;
  //Shift the buffer by mean value
  for (int i=0; i<N; i++) {
    buffer[i] -= mean;
  }
  
 for (int i=0; i<N; i++) {
    //println(buffer[i]);
  }
  
}




