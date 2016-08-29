class Walker { 

  PVector pos;
  boolean stuck;

  Walker () {
    pos = randPoint();
  }

  Walker ( PVector p, boolean s) {
    pos = p;
    stuck = s;
  }

  PVector getPos() {
    return this.pos;
  }

  //aux func to generate point in edges
  PVector randPoint() {
    int i = floor(random(4));
    if ( i==0 ) {
      float x = random(width);
      return new PVector( x, 0f);
    } else if ( i==1 ) {
      float x = random(width);
      return new PVector( x, height);
    } else if ( i==2 ) {
      float y = random(height);
      return new PVector( 0, y);
    } else {
      float y = random(height);
      return new PVector( width, y);
    }
  }

  void walk() {
    PVector vel = PVector.random2D();
    this.pos.add(vel); 
    this.pos.x = constrain(this.pos.x, 0, width);
    this.pos.y = constrain(this.pos.y, 0, height);
  } //end of func 


  //a faster distance calculation to eleminate the dist()
  //because it uses a square root that is expensive
  float distSq( PVector a, PVector b ) {
    float dx = b.x - a.x;
    float dy = b.y - a.y;
    //should be sRoot(dx*dx + dy+dy)  
    return ( dx*dx + dy*dy);
  }


  //check if a walker is near neighbours
  boolean checkStuck( ArrayList<Walker> others ) {
    //while ( !stuck ){
    //get the distance from the walker to all the points in the tree
    for (int i = 0; i < others.size(); i++ ) {
      float d = distSq(this.pos, others.get(i).getPos() );
      //check if smaller thet threshold
      //NOTE that r needs to be sq because im not using root in distance function
      if ( d < (r*r*4) ) {
        this.stuck = true;
        return true;
      }
    }
    return false;
    //}
  }//end of func 

  void show() {
    //run trough all points in the tree
    noStroke();
    if (this.stuck) {
      fill(255, 0, 100);
    } else {
      fill (255, 100);
    }
    ellipse(this.pos.x, this.pos.y, r*2, r*2);
  }//end of func
}//end of class 