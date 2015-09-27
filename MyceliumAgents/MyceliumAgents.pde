
ArrayList hifaHeap;

import processing.video.*;
Capture myCapture;

int TamanhoMaxHifas=9000;


void setup() {
  size(screenWidth, screenHeight);
  //size(600, 600);

  myCapture = new Capture(this, width, height, 10);

  background(255);
  smooth();

  hifaHeap = new ArrayList();
}

void draw() {
  //if (mousePressed){
  if (hifaHeap.size() <= 1 ) {
    for (int i=0; i<1; i++) {
      hifaHeap.add (new Hifa(random(50, width-50), random(50, height-50))); //starting point
    }
  }

  menuDraw();

  //matar se energia acaba
  for (int i=hifaHeap.size()-1; i>=0; i--) {
    Hifa h = (Hifa) hifaHeap.get(i);
    if (h.fDone) hifaHeap.remove(i);
    else h.grow();
  }
  //controlar tamanho
  if (hifaHeap.size()>= TamanhoMaxHifas) {
    for (int i=0; i<(hifaHeap.size()/2); i++) {
      Hifa h = (Hifa) hifaHeap.get(i);
      hifaHeap.remove(i);
    }
  }
}

void captureEvent(Capture myCapture) {
  // if (myCapture.available() == true) {
  myCapture.read();

  myCapture.loadPixels();
  //    for (int i = 0; i < myCapture.pixels.length;i++) {
  //      int b = (int)brightness(myCapture.pixels[i]);
  //      myCapture.pixels[i] = color(b);
  //      
  //    }
  //  }
}

void mouseDragged() {
  hifaHeap.add (new Hifa(mouseX, mouseY));
}

void keyPressed() {

  if (keyCode == 'z' || keyCode == 'Z') reset();
  if (keyCode == 'g' || keyCode == 'G') generate();
}


void reset() {
  hifaHeap.clear();
  background(255);
}

void generate() {
  for (int i=0; i<50; i++) {
    hifaHeap.add (new Hifa(random(5, width-5), random(5, height-5))); //starting point
  }
}

void menuDraw() {
  image(myCapture, 10, 17, 90, 60);
  noStroke();
  fill(0);
  rect(10, 2, 90, 15);
  rect(10, 77, 90, 25);
  fill(255);
  text("hifas_"+hifaHeap.size(), 15, 13);
  text("z_reset", 15, 87);
  text("g_generate", 15, 97);
}

