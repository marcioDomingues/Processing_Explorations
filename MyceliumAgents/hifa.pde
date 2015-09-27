class Hifa {
  PVector loc, vel, aux;
  float energy = 0;
  boolean fDone = false;

  Hifa(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector(random(1)-0.5, random(1)-0.5);

    aux = new PVector(x, y);
  }

  void grow() {    
    energy += _eatImgLum();
    if (energy > 10) {
      energy -= 10;
      PVector dir = _nextDir();
      PVector d = PVector.sub(vel, dir);
      d.normalize();
      vel.add(d);
      vel.limit(1.5);
      loc.add(vel);
      if (loc.x < 0) loc.x = width-1;
      if (loc.x >= width) loc.x = 0;
      if (loc.y < 0) loc.y = height-1;
      if (loc.y >= height) loc.y = 0;
      _plop();

      if (energy>10000 ) {
        energy -=10000;
        hifaHeap.add(new Hifa(loc.x, loc.y));
      }
    }
    energy -= 5;
    if (energy <= 0) fDone = true;
  }

  PVector _nextDir() {
    PVector retVal = new PVector(0, 0);
    float retB = 0, b = 0;
    for (int yy = -1; yy<=1; yy++)
      for (int xx = -1; xx<=1; xx++) {
        b = _imgLum(int(loc.x+xx), int(loc.y+yy));
        if (b > retB) {
          retB = b;
          retVal = new PVector(xx, yy);
        }
      }
    if (b == 0) retVal = new PVector(random(2)-1, random(2)-1);
    retVal.normalize();
    return retVal;
  }

  float _eatImgLum() {
    float retVal = 0.0;
    int imgPos = int(loc.x) + int(loc.y) * width;
    if (imgPos < width*height && imgPos > 0) {
      float b = brightness(myCapture.pixels[imgPos]);
      retVal = b*.65;
      myCapture.pixels[imgPos] -= color(b-retVal);
    }
    return retVal;
  }

  float _imgLum(int x, int y) {
    float retVal = 0.0;
    int imgPos = x + y * width;
    if (imgPos < width*height && imgPos > 0)
      retVal = brightness(myCapture.pixels[imgPos]);
    return retVal;
  }

  void _plop() {
    int tom = (int)_imgLum(int(loc.x), int(loc.y));

    //tom = (int)(map(tom, 0, 256, 0, 200));
    int pen=(int)map(tom, 0, 256, 2, 0);

    strokeWeight(pen);
    stroke(tom);

    if (loc.x< width-2 && loc.x>2 && loc.y<height-2 && loc.y>2 ) {
      line(loc.x, loc.y, aux.x, aux.y);
    }
    aux.set(loc);
  }
}



