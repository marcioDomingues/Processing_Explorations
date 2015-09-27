//////////////////////////////////////////// gui funtions

void setupGUI() {

  color c1 =0x88FFFFFF;//transparent white
  color c2 =0x33FFFFFF;//more transparent white

  color activeColor = color(50, 50, 50);//selection grey
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(c2);
  controlP5.setColorForeground(c1);
  controlP5.setColorLabel(color(50));
  controlP5.setColorValue(color(0, 0, 0));

  ControlGroup ctrl = controlP5.addGroup("menu", 2, 15, 5);
  //ctrl.setLabel(" ");//menu
  //ctrl.setColorLabel(color(25));
  ctrl.hideBar();//desaparece
  ctrl.close();

  sliders = new Slider[10];
  ranges = new Range[10];
  toggles = new Toggle[10];
  buttons = new Button[10];


  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int ri = 0;
  int ti = 0;
  int bi = 0;


  int posY = 0;
  int posX = 100;

  sliders[si] = controlP5.addSlider("zScale", -100, 100, left+posX, top+posY+0, len, 15);
  sliders[si++].setLabel("zScale");

  sliders[si] = controlP5.addSlider("zoom", -100, 100, left+posX, top+posY+20, len, 15);
  sliders[si++].setLabel("zoom");
  posY += 70;

  buttons[bi] = controlP5.addButton("OscSend", 0, left+(posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl);

  buttons[bi] = controlP5.addButton("generateTik", 0, left+(2*posX), top+posY, 80, 19);
  buttons[bi].setLabel("tikSend");
  buttons[bi].moveTo(ctrl);
  
  toggles[ti] = controlP5.addToggle("isWireframe", isWireframe,left+(5*posX), top+posY, 15, 15);
  toggles[ti++].setLabel("Wireframe");

  posY += 30; 

  buttons[bi] = controlP5.addButton("camera1", 0, left+(posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl);
  buttons[bi] = controlP5.addButton("camera2", 255, left+(2*posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl);
  buttons[bi] = controlP5.addButton("camera3", 128, left+(3*posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl); 
  buttons[bi] = controlP5.addButton("camera4", 128, left+(4*posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl);
  
  toggles[ti] = controlP5.addToggle("activatePeasy", peasyActive, left+(5*posX), top+posY, 15, 15);
  toggles[ti++].setLabel("Peasy on/off");
  
  posY += 55;
  
  buttons[bi] = controlP5.addButton("print", 128, left+(posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl);
  buttons[bi] = controlP5.addButton("Reset", 128, left+(2*posX), top+posY, 80, 19);
  buttons[bi].moveTo(ctrl); 
  posY += 35;




  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].captionLabel().toUpperCase(true);
    sliders[i].captionLabel().style().padding(4, 0, 1, 3);
    sliders[i].captionLabel().style().marginTop = -4;
    sliders[i].captionLabel().style().marginLeft = 0;
    sliders[i].captionLabel().style().marginRight = -14;
    sliders[i].captionLabel().setColorBackground(0x99ffffff);
  }

  for (int i = 0; i < ri; i++) {
    ranges[i].setGroup(ctrl);
    ranges[i].setId(i);
    ranges[i].captionLabel().toUpperCase(true);
    ranges[i].captionLabel().style().padding(4, 0, 1, 3);
    ranges[i].captionLabel().style().marginTop = -4;
    ranges[i].captionLabel().setColorBackground(0x99ffffff);
  }

  for (int i = 0; i < ti; i++) {
    toggles[i].setGroup(ctrl);
    //toggles[i].setColorLabel(color(50));
    toggles[i].captionLabel().style().padding(4, 3, 1, 3);
    toggles[i].captionLabel().style().marginTop = -19;
    toggles[i].captionLabel().style().marginLeft = 18;
    toggles[i].captionLabel().style().marginRight = 5;
    toggles[i].captionLabel().setColorBackground(0x99ffffff);
  }

  for (int i = 0; i < bi; i++) {
    buttons[i].setGroup(ctrl);
    buttons[i].setColorLabel(color(50));
    buttons[i].captionLabel().style().padding(4, 3, 1, 3);
    buttons[i].captionLabel().style().marginTop = -19;
    buttons[i].captionLabel().style().marginLeft = 33;
    buttons[i].captionLabel().style().marginRight = 5;
    buttons[i].captionLabel().setColorBackground(0x99ffffff);
  }
}

void drawGUI() {
  controlP5.show();
  controlP5.draw();
}

// called on every change of the gui
void controlEvent(ControlEvent theEvent) {
  guiEvent = true;

  showGUI = controlP5.group("menu").isOpen();

  //println("got a control event from controller with id "+theEvent.controller().id());
  // noiseSticking changed -> set new values

  //  if(theEvent.isController()) {
  //    if (theEvent.controller().name().equals("noiseStickingRange")) {
  //      for(int i=0; i<agentsCount; i++) agents[i].setNoiseSticking(noiseStickingRange);  
  //    }
  //    else if(theEvent.controller().name().equals("agentWidthRange")) {
  //      float[] f = theEvent.controller().arrayValue();
  //      agentWidthMin = f[0];
  //      agentWidthMax = f[1];
  //    }
  //  }
}

void isWireframe() {
  isWireframe=!isWireframe;
}
void generateTik() {
  createClock();
}
void OscSend() {
  oscSendAgentsArray(AgentsSent);//sends the counter step 1 for all agents
  println("osc message sent");
}

void camera1() {
  camera(0, 250, 60, 0, 0, 0, 0, 1, 0);
  controlP5.group("menu").close();
}
void camera2() {
  camera(0, 0, 250, 0, 0, 0, 0, 1, 0);
  controlP5.group("menu").close();
}
void camera3() {
  camera(250, 250, 250, 0, 0, 0, 0, 1, 0);
  controlP5.group("menu").close();
}
void camera4() {
  camera(-100, 400, 300, 0, 0, 0, 0, 1, 0);
  controlP5.group("menu").close();
}

void activatePeasy() {
 peasyActive = !peasyActive;

}

void Reset() {
  controlP5.group("menu").close(); 
  setup();
}

void print() {
  println(clocks.size()+ " clocks");
  println("frame n>>"+frameToTrigger);
  println("trigger at frame n>>"+trigger);
}


