

void setupGUI() {
  color activeColor = color(0, 130, 164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorCaptionLabel(color(50));
  controlP5.setColorValueLabel(color(255));

  ControlGroup ctrl = controlP5.addGroup("menu", 15, 25, 35);
  ctrl.setColorLabel(color(255));
  ctrl.close();

  sliders = new Slider[10];

  toggles = new Toggle[30];


  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  //int ri = 0;
  int posY = 0;

  int ti = 0;


  sliders[si++] = controlP5.addSlider("seedWorld", 1, 50, left, top+posY+0, len, 15);
  posY += 30;

  sliders[si++] = controlP5.addSlider("seedSize", 1, 20, left, top+posY+0, len, 15);
  //  sliders[si++] = controlP5.addSlider("noiseStrength",0,100,left,top+posY+20,len,15);
  posY += 50;

  //  sliders[si++] = controlP5.addSlider("noiseStickingRange",0,5,left,top+posY+0,len,15);
  //  posY += 30;

  sliders[si++] = controlP5.addSlider("dA", 0.0, 1.0, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("dB", 0.0, 1.0, left, top+posY+20, len, 15);
  posY += 50;
  
  sliders[si++] = controlP5.addSlider("feed", 0.010, 0.090, left, top+posY+0, len, 15);
  sliders[si++] = controlP5.addSlider("k", 0.010, 0.090, left, top+posY+20, len, 15);
  posY += 50;

  
  //  sliders[si++] = controlP5.addSlider("strokeWidth",0,10,left,top+posY+0,len,15);
  // // ranges[ri++] = controlP5.addRange("agentWidthRange",0,50,agentWidthMin,agentWidthMax,left,top+posY+20,len,15);
  //  posY += 30;

  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].getCaptionLabel().toUpperCase(true);
    sliders[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    sliders[i].getCaptionLabel().getStyle().marginTop = -4;
    sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
    sliders[i].getCaptionLabel().getStyle().marginRight = -14;
    sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }



  // toggles[ti] = controlP5.addToggle("invertBackground",invertBackground,left+0,top+posY,15,15);
  // toggles[ti++].setLabel("Invert Background");
  // posY += 50;

  toggles[ti] = controlP5.addToggle("populate", populate, left+0, top+posY, 15, 15);
  toggles[ti++].setLabel("populate"); 
  toggles[ti] = controlP5.addToggle("clear", clear, left+100, top+posY, 15, 15);
  toggles[ti++].setLabel("clear"); 

  //toggles[ti] = controlP5.addToggle("drawZ",drawZ,left+200,top+posY,15,15);
  //toggles[ti++].setLabel("Draw Z"); 
  posY += 50;

  // toggles[ti] = controlP5.addToggle("lockX",lockX,left+0,top+posY,15,15);
  // toggles[ti++].setLabel("Lock X"); 
  // toggles[ti] = controlP5.addToggle("lockY",lockY,left+100,top+posY,15,15);
  // toggles[ti++].setLabel("Lock Y"); 
  // toggles[ti] = controlP5.addToggle("lockZ",lockZ,left+200,top+posY,15,15);
  // toggles[ti++].setLabel("Lock Z"); 
  // posY += 20;

  for (int i = 0; i < ti; i++) {
    toggles[i].setGroup(ctrl);
    toggles[i].setId(i);
    toggles[i].getCaptionLabel().toUpperCase(true);
    toggles[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    toggles[i].getCaptionLabel().getStyle().marginTop = -4;
    toggles[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }
}

void drawGUI() {
  controlP5.show();
  controlP5.draw();
}

// called on every change of the gui
void controlEvent(ControlEvent theEvent) {
  //println("got a control event from controller with id "+theEvent.getController().getId());
  // noiseSticking changed -> set new values

  if (theEvent.isController()) {
    if (theEvent.getController().getName().equals("populate")) {
      populate ( seedWorld, seedSize );
    }
     if (theEvent.getController().getName().equals("clear")) {
      clearWorld ( );
    }
    //    if (theEvent.getController().getName().equals("bufferSize")) {
    //      int nb = int(theEvent.getController().getValue());
    //      println( "bang" + nb );
    //      
    //      editDetector.pp();
    //
    //      editDetector.initBuffer(nb);
    //
    //      editDetector.pp();
    //    }

    // if (theEvent.getController().getName().equals("noiseStickingRange")) {
    //   //for(int i=0; i<agentsCount; i++) agents[i].setNoiseSticking(noiseStickingRange);  
    // }

    // else if(theEvent.getController().getName().equals("agentWidthRange")) {
    //   float[] f = theEvent.getController().getArrayValue();
    //   //agentWidthMin = f[0];
    //   //agentWidthMax = f[1];
    // }
  }
}







