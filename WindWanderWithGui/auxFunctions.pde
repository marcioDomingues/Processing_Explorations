//_______________world wrap Funtions_______________
int wrapx (int x) {
  if (x>=mesh_w-1) x = (x % (mesh_w-1))+1;
  else if (x<=1) x= (mesh_w-1)-abs(x); 
  return x;
}

int wrapy (int y) {
  if (y>=mesh_h-1) y=(y%(mesh_h-1))+1;
  else if (y<=1) y=(mesh_h-1)-abs(y); 
  return y;
}


//_______________color Funtions_______________
void coloring(float bottomColor, float midColor, float topColor, float c, float threshold) {
  float interColor;
  if (c <= threshold) {
    float amount = map(c, 0, threshold, 0, 1);
    interColor = lerp(bottomColor, midColor, amount);
  } 
  else {
    float amount = map(c, threshold, 1, 0, 1);
    interColor = lerp(midColor, topColor, amount);
  }

  if (!isWireframe) {
    fill(interColor);
    noStroke();
  }
  else {
    stroke(interColor, 0.4);
    fill(interColor, 0.7);
  }
}



//_______________OSC Funtions_______________
//_______________send line gradient_______________
void oscSend(int numberOfLines, int y) {
  int n=numberOfLines; //number of lines to send
  int yLine = y;       //mousse position for test 
  float value;

  //_______________send the values of n lines
  for (int i=0; i<n; i++ ) {//sends n messages 

    //yLine=int(random(0, height)); //selects a random Ypos line to send
    String onelongstring="";      //creates a string for values

    OscMessage myMessage = new OscMessage("/test"+i);

    for (int x=0; x<mesh_w; x=x+5 ) { //because of the string size it reads every 5 
      //100 readings and uses / to split  
      value = ca.readingValue(x, yLine);   
      onelongstring = onelongstring+value+"/";
    }     
    onelongstring = onelongstring+"\n";//puts end of the line in the string 
    myMessage.add(yLine); /* add an int with Y line pos to the osc message */
    myMessage.add(onelongstring); /* add a string with readings to the osc message */

    oscP5.send(myMessage, myRemoteLocation);
  }
}
//_______________send agents x<>y_pos_______________
void oscSendAgents(int agentDivider) {
  int n = agentDivider ; //number of lines to send
  int x_pos, y_pos;

  String onelongstring="";  //creates a string for values
  OscMessage myMessage = new OscMessage("/test");

  //_______________send the values of n of agents
  for (int i=0;i<agents.size();i=i+agentDivider) {//sends n messages 
    Agent a =(Agent)agents.get(i);
    //readings and uses / to split  
    x_pos = int(a.pos.x);   
    y_pos = int(a.pos.y);
    
    println("x>>"+ x_pos);
    println("y>>"+ y_pos);
    
    onelongstring = onelongstring+x_pos+"_"+y_pos+"/"; //tokens "_" and "/"
  }     
  onelongstring = onelongstring+"\n";//puts end of the line in the string 

  myMessage.add((agents.size()/n)); /* add an int with n of agents to the osc message */
  myMessage.add(onelongstring); /* add a string with readings to the osc message */

  oscP5.send(myMessage, myRemoteLocation);
}


//_______________send agents x y Array_______________
void oscSendAgentsArray(int agentDivider) {
  int n = agentDivider ; //number of lines to send
  int x_pos, y_pos;

  String onelongstring="";  //creates a string for values
  OscMessage myOscMessage = new OscMessage("/test");
  
  int messageSize=agents.size()/agentDivider;
  int[][] outputSC = new int[messageSize][2];  
  
  //_______________send the values of n of agents
  for (int i=0;i<messageSize;i++) {//sends n messages 
    
    Agent a =(Agent)agents.get(i);
    //readings and uses / to split  
    x_pos = int(a.pos.x);   
    y_pos = int(a.pos.y);
    
    outputSC[i][0] = x_pos;
    outputSC[i][1] = y_pos;

  }      
  
  myOscMessage.add(messageSize);
  myOscMessage.add(outputSC);
  
  oscP5.send(myOscMessage, myRemoteLocation);
}


//_______________draw text and gui_______________
void drawText( int agentDivider ) {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  
  ambientLight(1, 1, 1);
  
  int agentSent=agents.size()/agentDivider;//print the same agents sent over osc

  for (int i=0;i<agentSent;i++) {
    Agent a =(Agent)agents.get(i);
    fill(1, 1, 1, 0.3);
    text(i+"_"+"["+int(a.pos.x)+"_"+int(a.pos.y)+"]", 2, (10*i)+25 );
  }
  
  pushMatrix();
  
  translate(width-110, height-110, 0);
  // colorMode(HSB,1);
  for (int x=0; x<100; x++) {
    for (int y=0; y<100; y++) {
      float c=ca.readingValue( int(map(x, 0, 100, 0, mesh_w)), int(map(y, 0, 100, 0, mesh_h)));
      stroke(c, 1); 
      point(x, y);
    }
  }
  popMatrix();
  // colorMode(RGB,1);
  //rect(0, 0, 100, 100);
  
  
  g3.camera = currCameraMatrix;
}


//_______________generate clock_______________
void createClock () {
  if (clocks.size() < 6) {
    clocks.add(new Clock(new PVector ( random(50, mesh_w-50), random(50, mesh_h-50), 0 ), random(0.2, 1.0)));
  }
}
