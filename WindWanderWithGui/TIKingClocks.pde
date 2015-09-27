class Clock {//i will assume clocks dont tik simultaneous
  PVector posVector;
  int life;
  int  raio=0;
  float masses;
  float aux; 
 // ------ constructor ------
  Clock(PVector _pos, float mass) {
    posVector = _pos; 
    aux = mass;
    masses=aux;
  }
 // ------ methods ------
  void TIK() {
    PVector circle=new PVector(0, 0, 0);
    float angle = 0;

    Spotlights( posVector );

    for (float j=0; j<360; j++) {   
      circle.x = posVector.x +cos(radians(angle))*raio;
      circle.y = posVector.y +sin(radians(angle))*raio;

      circle.x= wrapx(int(circle.x));
      circle.y= wrapy(int(circle.y));

      if (circle.x>0&&circle.x<mesh_w-1&&circle.y>0&&circle.y<mesh_h-1) {
        ca.cell[int(circle.x)][int(circle.y)][1]=masses;
      }
      angle++;
    }
    raio=raio+3;
  }

  void TIKLife() {
    masses=masses-0.01;
    if (masses < -0.3) {
      raio=0;
      masses=aux;
    }
  }

  void Spotlights( PVector pos ) {
    pushMatrix();
      translate( -(mesh_w/2), -(mesh_w/2), zoom);
  
      pointLight(0.6, 0.6, 0.6, pos.x, pos.y, map(masses, 0.0, 1.0, 0, 300 ));
      //spotLight(0.8, 0.8, 0.8, pos.x ,pos.y  , map(masses, 0.0 ,1.0 , 0 , 300 ) , 0, 0, -1, radians(60), 1);
  
     // stroke(255, 255, 255, masses);
     // line(pos.x, pos.y, map(aux, 0.0, 1.0, 0, 200), pos.x, pos.y, map(masses, 0.0, 1.0, 0, 200));
    popMatrix();
  }
  
  
  
  
}//end 

