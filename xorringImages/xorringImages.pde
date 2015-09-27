
PImage img;
boolean matrix[], backup[];
boolean flip = true;

import processing.video.*;
Capture myCapture;

 int l=150;//(int)random(100,200);

int offsets[] = {
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 5, 5, 5, 5, 5, 5, 5, 5, 6, 8, 13, 23, 16, 3, 7, 3, 2
};
//////////////////////////////////////////////////
void setup() {
  size(screenWidth,screenHeight,P2D);
  //size(400, 400, P2D);
  noiseSeed(19);

  matrix = new boolean[width*height];
  backup = new boolean[width*height];

  background(12);

  myCapture = new Capture(this, width, height, "USB Video Class Video", 10);
}
//////////////////////////////////////////////////
void draw() {

  pushMatrix();
  translate(10, 10);
  myCapture.filter(GRAY);
  image(myCapture, 0, 0, 50, 50); 
  popMatrix();


  if (frameCount%300 > 1 && frameCount%300 < 30) {
    capture();
  }

  int offset = offsets[frameCount%offsets.length];

  //fastblur(g,(int)((noise(frameCount/5.0))*20.0));
  loadPixels();
  for (int i = 0 ; i < pixels.length;i++) {
    matrix[i] |= backup[i];
    matrix[i] ^= matrix[(i+offset+pixels.length)%matrix.length];
    pixels[i] += 0.5*(matrix[(i-offset+pixels.length)%matrix.length]?0xffffffff:0xff000000);
  }
  updatePixels();

  strokeWeight(5);
  stroke(0, 30);
  noFill();
  rect(0, 0, width, height);


  if (frameCount%600 == 0 ) {
    checkColor();
    println("checkFrame_"+frameCount);
  }


  soundModule();
}

/////////////////////////////////////////////////

void captureEvent(Capture myCapture) {
  myCapture.read();
}

void checkColor() {
  float sum=0;
  for (int i=0; i < pixels.length; i++) {
    sum+=brightness(pixels[i]);
  }
  int b=(int)(sum/pixels.length);
  //  println(b);

  if (b < 50) {
    l=(int)random(100,300);
    background(12);
    capture();
  }
}

void capture() {
  myCapture.loadPixels();
  loadPixels();
  for (int i = 1;i<matrix.length;i++) {
    backup[i] = matrix[i] = brightness(myCapture.pixels[i])>120?true:false;
    matrix[i] = brightness(myCapture.pixels[i])>=180?true:false;
  }
  updatePixels();
}



void soundModule() {
 
  int row[];
  row = new int[width];

  for (int i = 0 ; i<width; i++) { 
    //row[i] = (int)brightness((get(l, i)));
    //row[i] = matrix[(int)random(0,matrix.length)];
    row[i] = (int)brightness(pixels[i*l]);
   // print(row[i]+", ");
  }
 // println("eof");

  pushMatrix();
  //
  stroke(255);
  strokeWeight(1);
  line(0, l+2, width, l+2);
  //
  translate(width-150, height-150);

  noStroke();
  fill(0);
  rect(0, 0, 130, 130);
    //  
    //  

    //  
    for (int i = 0 ; i < 130; i++) {
      stroke(row[(int)random(0,width)]);
      line(i, 0, i, 130);

      //
    }  
  //
  popMatrix();
}

