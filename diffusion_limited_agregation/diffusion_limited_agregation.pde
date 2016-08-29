
/**
 * Diffusion-limited agregation 
 * from paul bourke http://paulbourke.net/fractals/dla/ 
 * and example from Daniel Shiffman - coding challenge #34
 * 
 */

ArrayList <Walker> tree = new ArrayList<Walker>() ;

ArrayList <Walker> walkers = new ArrayList<Walker>() ;
//radius for elements
int r = 4;

//we can add less points over more iterations
// or more points in fewer iterations
int maxWalkers = 1000;
int iterations = 200;



void setup() {
  size(500, 500);

  //we can add the seed point in diferent parts of the screen 
  //and the location of the walker generation
  //to have diferent aperances
  // we can also change the walker walking vector so they have a 
  // tendance to a specific direction
  tree.add( new Walker(new PVector(width/2, height/2), true ) );
  //tree.add( new Walker( new PVector(width/2, height), true ) );

  for (int i = 0; i < maxWalkers; i++ ) {
    walkers.add(new Walker());
  }
}

void draw() {
  background(0);


  for (int i = 0; i < tree.size(); i++ ) {
    tree.get(i).show();
  }

  for (int i = 0; i < walkers.size(); i++ ) {
    walkers.get(i).show();
  }

  for (int n = 0; n < iterations; n++ ) {
    for (int i = 0; i < walkers.size(); i++ ) {
      walkers.get(i).walk();
      //walkers.get(i).show();

      if ( walkers.get(i).checkStuck( tree ) ) {
        tree.add( walkers.get(i));
        walkers.remove(i);
      }
    }
  }

  //to always have the same n of walkers
  //while(walkers.size() < maxWalkers){
  //  walkers.add(new Walker());
  //}
}