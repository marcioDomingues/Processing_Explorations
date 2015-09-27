


public class Branch  {

    Vec3D loc;
    Vec3D orig_loc;
    Vec3D vel;

    int generations;

    String type;


    public Branch (Vec3D _loc, Vec3D _vel, int _generations, String _type) {

        loc = _loc;
        orig_loc = _loc.copy();
        vel = _vel; 
        generations = _generations;
        
        type = _type;
        //vel = new Vec3D (100,0,0);

        //stack of func executed only once
        updateDir();
        updateLoc();
        spawn();


    }


    void run(){

        display();
        //updateLoc();
    }


    void spawn(){

        if (generations > 0) {

            //type A branch into 2, 1 of type A and 1 of B 
            if (type == "A") {
                Vec3D ini_pos = loc.copy();
                Vec3D ini_vel = vel.copy();
                Branch newBob = new Branch (ini_pos, ini_vel , generations-1, "A" );

                allBobs.add(newBob);


                Vec3D ini_pos2 = loc.copy();
                Vec3D ini_vel2 = vel.copy();
                Branch newBob2 = new Branch (ini_pos2, ini_vel, generations-1, "B" );

                allBobs.add(newBob2);
            }

            //type B branch into 1 of type C
            if (type == "B") {
                Vec3D ini_pos = loc.copy();
                Vec3D ini_vel = vel.copy();
                Branch newBob = new Branch (ini_pos, ini_vel, generations-1, "C" );

                allBobs.add(newBob);

            }

            //type C branch into 1 of type A
            if (type == "C") {
                Vec3D ini_pos = loc.copy();
                Vec3D ini_vel = vel.copy();
                Branch newBob = new Branch (ini_pos, ini_vel, generations-1, "A" );

                allBobs.add(newBob);
            }
        }

    }


    void updateDir(){

        if (type == "A") {
            float angle1 = radians(ANGLE_A_X);
            float angle2 = radians(ANGLE_A_Y); 
            float angle3 = radians(ANGLE_A_Z);

            vel.rotateX(angle1);
            vel.rotateY(angle2);
            vel.rotateZ(angle3);

            vel.normalize();
            vel.scaleSelf( BRANCH_A );
        }

        if (type == "B") {
            float angle1 = radians(ANGLE_B_X);
            float angle2 = radians(ANGLE_B_Y);
            float angle3 = radians(ANGLE_B_Z);
            
            vel.rotateX(angle1);
            vel.rotateY(angle2);
            vel.rotateZ(angle3);

            vel.normalize();
            vel.scaleSelf( BRANCH_B );
        }

        if (type == "C") {
           float angle1 = radians(ANGLE_C_X);
           float angle2 = radians(ANGLE_C_Y);
           float angle3 = radians(ANGLE_C_Z);

           vel.rotateX(angle1);
           vel.rotateY(angle2);
           vel.rotateZ(angle3);

           vel.normalize();
           vel.scaleSelf( BRANCH_C );
       }

 }

 void updateLoc(){

    loc.addSelf(vel);

}

void display(){
    stroke(255, 0, 0);
    strokeWeight(4);
    point(loc.x,loc.y,loc.z);


    stroke(255);
    strokeWeight(0.4);
    line(loc.x, loc.y, loc.z, orig_loc.x, orig_loc.y, orig_loc.z);
}






}