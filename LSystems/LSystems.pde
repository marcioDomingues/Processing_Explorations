
//TODO
//make an STL export
import toxi.geom.*;
import peasy.*;

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;



private ControlP5 cp5;
ControlFrame cf;

PeasyCam cam;

//p5 slider variables instances
float ANGLE_A_X;
float ANGLE_A_Y;
float ANGLE_A_Z;

float ANGLE_B_X;
float ANGLE_B_Y;
float ANGLE_B_Z;

float ANGLE_C_X;
float ANGLE_C_Y;
float ANGLE_C_Z;

int BRANCH_A;
int BRANCH_B;
int BRANCH_C;

int ITER;

//iniciation
Branch bob;

ArrayList <Branch> allBobs;


void setup() {
    size(800, 800,P3D);
    smooth();

    cam = new PeasyCam(this, 100);

    cp5 = new ControlP5(this);    
    // by calling function addControlFrame() a
    // new frame is created and an instance of class
    // ControlFrame is instanziated.
    cf = addControlFrame("UI", 380,450);
    // add Controllers to the 'extra' Frame inside 
    // the ControlFrame class setup() method below.


    allBobs = new ArrayList <Branch> ();
}

void draw() {
    background(0);
    frame.setTitle(int(frameRate) + " fps");
    
    
    //peasy control cube
    //stroke(255);
    //noFill();
    //strokeWeight(1);
    //box(600);

    //
    allBobs.clear();

    Vec3D ini_pos = new Vec3D (0,0,0);
    Vec3D ini_vel = new Vec3D (100,0,0);
    
    bob = new Branch (ini_pos, ini_vel, ITER, "A");

    allBobs.add(bob);
    
    //for each loop
     for (Branch b : allBobs) {
      b.run();
    }
     
   
   
   
   

}


///////////////////////////////////////////////////////////
///call to th constructor
///////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////
///use event listener to draw only on change
///////////////////////////////////////////////////////////
void controlEvent(ControlEvent theEvent) {

  
  if (theEvent.isFrom(cp5.getController("n1"))) {
    println("this event was triggered by Controller n1");
  }
  
  switch(theEvent.getController().getId()) {
    case(1):
    println("this event was triggered by Controller");
    //myColorRect = (int)(theEvent.getController().getValue());
    break;
    case(2):
    //myColorBackground = (int)(theEvent.getController().getValue());
    break;
    case(3):
    //println(theEvent.getController().getStringValue());
    break;
    default :
    println("one of them");
    break;  
  }
}

