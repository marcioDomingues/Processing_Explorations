class CA {
  float[][][] cell;
 
  // grid definition horizontal
  int Count = 150;
  float gridMin = 0;
  float gridMaxX = mesh_w;
  float gridMaxY = mesh_h;

  // array for the grid points
  // initialize array
  PVector[][] points = new PVector[Count+1][Count+1];

  // ------ try ------

  // ------ mesh ------
  int tileCount = 300;
 // int zScale = 0;

  // ------ mesh coloring ------
  float midColor, topColor, bottomColor;
  float threshold = 0.50;

 // ------ constructor ------
  CA() {
    // colors
    topColor = 1;
    midColor = 0.2;
    bottomColor = 0;  

    //create and fill array
    cell=new float[mesh_w+1][mesh_h+1][2]; 
    for (int x=0;x<mesh_w;x++) {
      for (int y=0;y<mesh_h;y++) {
        cell[x][y][1]=random(1);
      }
    }
  
}

// ------ methods ------
  float readingValue( int x, int y) {
    x=wrapx(x);
    y=wrapy(y);
    return cell[x][y][1];
  }


  void run() {
    for (int x=0;x<mesh_w;x++) {
      for (int y=0;y<mesh_h;y++) { 
        cell[x][y][0]=cell[x][y][1];
        //set(x,y,color(1-cell[x][y][1],cell[x][y][1],cell[x][y][1]));
      }
    }

    for (int x=0;x<mesh_w;x++) {
      for (int y=0;y<mesh_h;y++) {  
        float nVal=neighbors(x, y);
        cell[x][y][1]=nVal/8.01;
      }
    }
    
  }

  float neighbors(int x, int y) {
    float val;
    x=wrapx(x);
    y=wrapy(y);
    // if(x>0&&x<width-1&&y>0&&y<height-1){
    val=cell[x+1][y][0]+
      cell[x-1][y][0]+
      cell[x+1][y+1][0]+
      cell[x+1][y-1][0]+
      cell[x][y-1][0]+
      cell[x][y+1][0]+
      cell[x-1][y+1][0]+
      cell[x-1][y-1][0];

    return val;
  }



  void fillArray() {
    float u, v;
    
    for (int iv = 0; iv <= Count; iv++) {
      for (int iu = 0; iu <= Count; iu++) {

        u = map(iu, 0, Count, gridMin, gridMaxX);
        v = map(iv, 0, Count, gridMin, gridMaxY);

        points[iv][iu] = new PVector();
        points[iv][iu].x = v;
        points[iv][iu].y = u;
        points[iv][iu].z = (readingValue( int(v), int(u))) * zScale;
      }
    }
  }

  void fillTerrain() {
    //center of the mesh
    // stroke(0,1,0);
    // line(mesh_w/2, mesh_h/2, -100, mesh_w/2, mesh_h/2, 100); 

    for (int iv = 0; iv < Count; iv++) {
      beginShape(QUAD_STRIP);
      for (int iu = 0; iu <= Count; iu++) {

        float u = map(iu, 0, Count, gridMin, gridMaxX);
        float v = map(iv, 0, Count, gridMin, gridMaxY);

        float c= cell[int(v)][int(u)][1];
        
        coloring ( bottomColor, midColor, topColor, c, threshold);

        vertex(points[iv][iu].x, points[iv][iu].y, points[iv][iu].z);
        vertex(points[iv+1][iu].x, points[iv+1][iu].y, points[iv+1][iu].z);
      }
      endShape();
    }
  }

}//end 

