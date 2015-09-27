class Agent {
  PVector pos, vel;
  int searchDist; 
 // ------ constructor ------
  Agent(int _x, int _y, int _z) {
    pos=new PVector(_x, _y, _z);  
    vel=new PVector(random(-1, 1), random(-1, 1), 0);
    searchDist=2;//how much an agent knows about its surroundings
  }
 // ------ methods ------
  void move() {
    for (int x=(int)pos.x-searchDist;x<=(int)pos.x+searchDist;x++) {
      for (int y=(int)pos.y-searchDist;y<=(int)pos.y+searchDist;y++) {
        if (x!=(int)pos.x&&y!=(int)pos.y) {

          if (ca.readingValue(x, y) < 0.5) {
            vel.mult(-1);
          }
        }
      }
    } 
    vel.limit(1);  
    pos.add(vel);
  }
  
  void display() {
    int x=wrapx(round(pos.x));
    int y=wrapy(round(pos.y));

    if (x>0&&x<mesh_w-1&&y>0&&y<mesh_h-1) {
      ca.cell[x][y][1]=1;
    }
  }
  
}//end 




