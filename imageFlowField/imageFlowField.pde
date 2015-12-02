/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */
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


//Control bools
boolean fieldImg = true;
boolean perpendicular = true;
boolean vector = true;
boolean backgroundImage = false;

//Control vars
int blurAmout = 1;

int n_vehicles=100;

// field object
Field field;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

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

  field = new Field( 640, 480, 8 );

  //shiffman vehicles class
  vehicles = new ArrayList<Vehicle>();
  
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  


  if ( blurAmout!=0 ) {
    cam.filter(BLUR, blurAmout);
  }


  field.update(cam);

  //Display stuff 
  if ( fieldImg ) {
    field.displayPixelField( "RGB" );
  } else if ( backgroundImage ) {
    set(0, 0, cam);
  } else {
     fill(0,5);
     rect(0,0,width,height);
  }

  if ( vector ) {
    field.displayField();
  }
  if ( perpendicular ) {
    field.displayPerpendicularField();
  }


  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    if (perpendicular) {
      v.followParallel(field);
    } else {
      v.follow(field);
    }

    v.run();
  }
}

void keyPressed() {
  if (key == ' ') {
    vehicles.clear();
  } else if ( key == 'n' ) {
    // Make a whole bunch of vehicles with random maxspeed and maxforce values
    for (int i = 0; i < n_vehicles; i++) {
      vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(2, 5), random(0.1, 0.5)));
    }
  }else if ( key == 'b' ) {
    background(0);
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

