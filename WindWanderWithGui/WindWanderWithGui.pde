import oscP5.*;//osc lib
import netP5.*;//osc lib
import processing.opengl.*;
import peasy.*;

import controlP5.*;

// ------ ControlP5 ------
ControlP5 controlP5;
ControlGroup ctrl;
boolean showGUI = false;
boolean guiEvent = false;
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;
Button[]  buttons;

// ------ cam and peasy variables ------
PeasyCam cam;
boolean peasyActive = false;//off when menu is on
PMatrix3D currCameraMatrix;
PGraphics3D g3; 

OscP5 oscP5;
NetAddress myRemoteLocation;

// ------ objects ------
ArrayList agents; 
ArrayList clocks;
CA ca;

// ------ global variables ------
int agentsAmount=1000;
int numberClocks=0;

boolean isWireframe=true;

PFont fontA;

// ------ 3D mesh size ------
int mesh_w = 500;
int mesh_h = 500;

// ------ interaction ------
int zoom = 0;
int zScale = 0;
int AgentsSent= 20; 

// ------ fake clocks Trigger ------
int trigger = 0;
int frameToTrigger = 0;

//_______________Setup_______________
void setup() {
  //size(720, 500, OPENGL);
  size(screenWidth, screenHeight, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);

  colorMode(RGB, 1);
  noStroke();
  cursor(CROSS);
  // ------ cams ------
  g3 = (PGraphics3D)g;  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(500);

  camera(0, 250, 60, 0, 0, 0, 0, 1, 0);

  // ------ text ------  
  fontA = loadFont("OCRAStd-8.vlw");
  textAlign(LEFT);
  textFont(fontA, 8);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000); 
  //myRemoteLocation = new NetAddress("127.0.0.1", 57120);//local
  //myRemoteLocation = new NetAddress("192.168.200.119", 57120);//send to joeri
  myRemoteLocation = new NetAddress("192.168.1.16", 57120);//send to joeri
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  //_______________caSystem object that draws the world 
  ca=new CA();

  //_______________creating and filliong dynamic arrays of clocks and agents
  clocks=new ArrayList();

  agents=new ArrayList();
  for (int i=0;i<agentsAmount;i++) {
    agents.add(new Agent(round(random(10, mesh_w-10)), round(random(10, mesh_h-10)), 0 ));
  }
  //_______________ inicialize gui
  
  setupGUI();


  trigger=int(random(5, 100));
}//end setup


void draw() {  
  hint(ENABLE_DEPTH_TEST);
  background(0, 0, 0);
  ambientLight(0.15, 0.15, 0.15 );


  // ------ agents ------ 
  for (int i=0;i<agents.size();i++) {
    Agent a =(Agent)agents.get(i);
    a.move();
    a.display();
  }


  // ------ clocks ------ 
  for (int i=0;i<clocks.size();i++) {

    Clock a =(Clock)clocks.get(i);
    a.TIKLife();
    a.TIK();

    //println(a.masses);
    if (a.masses < -0.1  ) { //println("dead");
      remove(i);
    }
  }
  
  // ------ random trigger for clocks ------ 
  frameToTrigger = frameCount % 100;
  if ( frameToTrigger == trigger) {   
    createClock();
    oscSendAgentsArray(AgentsSent);//sends the counter step 1 for all agents
    println("osc message sent");
    trigger=(trigger+int(random(5, 100)))%100;
  }


  // ------ run system ------ 
  ca.run(); 
  ca.fillArray();

  pushMatrix();
  translate( -(mesh_w/2), -(mesh_w/2), zoom);
  ca.fillTerrain(); 
  popMatrix();


  // ------ other functions ------ 
  // makes the gui stay on top of elements
  // drawn text before
  hint(DISABLE_DEPTH_TEST);
  drawText(6);

   cam.setActive(peasyActive);//disable peasy cam when in gui modem
  
  drawGUI(); 
  if (showGUI == true) {
    text("frameRate_"+frameRate, 2, 12);
  }
  else {
    text("press>>m", 2, 12);
  }
  
}//end draw


void keyPressed() {
 
  if (key=='m' || key=='M') {
    showGUI = controlP5.group("menu").isOpen();
    showGUI = !showGUI;
  }
  if (showGUI) { 
    controlP5.group("menu").open();
  }
  else { 
    controlP5.group("menu").close();
  }
}



void remove(int agent) {
  clocks.remove(clocks.get( agent ));
}


