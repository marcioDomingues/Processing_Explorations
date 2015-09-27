import blobDetection.*;
import peasy.*;
PeasyCam cam;

PImage img;

float levels = 25;                    // number of contours
float factor = 1;                     // scale factor
float elevation = 55;                 // total height of the 3d model

float colorStart =  0;                // Starting degree of color range in HSB Mode (0-360)
float colorRange =  100;              // color range / can also be negative

// Array of BlobDetection Instances
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];

void setup() {
  size(1000,800,P3D);  
  img = loadImage("1.jpg");           // heightmap (about 250×250px)
  cam = new PeasyCam(this,200);
  colorMode(HSB,360,100,100);  

  //Computing Blobs with different thresholds 
  for (int i=0 ; i<levels ; i++) {
    theBlobDetection[i] = new BlobDetection(img.width, img.height);
     theBlobDetection[i].setThreshold(i/levels);
    theBlobDetection[i].computeBlobs(img.pixels);
  }
}

void draw() { 
  background(0);
  translate(-img.width*factor/2,-img.height*factor/2);

  for (int i=0 ; i<levels ; i++) {
    translate(0,0,elevation/levels);  
    drawContours(i);
  }
}

void drawContours(int i) {
  Blob b;
  EdgeVertex eA,eB;

  for (int n=0 ; n<theBlobDetection[i].getBlobNb() ; n++) {
    b=theBlobDetection[i].getBlob(n);
    if (b!=null) {
      stroke((i/levels*colorRange)+colorStart,100,100);      // coloring the contours

      for (int m=0;m<b.getEdgeNb();m++) {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);
        if (eA !=null && eB !=null)
          line(
          eA.x*img.width*factor, eA.y*img.height*factor, 
          eB.x*img.width*factor, eB.y*img.height*factor 
            );
      }
    }
  }
}
