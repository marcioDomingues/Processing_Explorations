

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

int w, h;

int abc = 100;

  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    //cp5.addSlider("abc").setRange(0, 255).setPosition(10,10);
    //cp5.addSlider("def").plugTo(parent,"def").setRange(0, 255).setPosition(10,20);


//USE KNOBS FOR THE ANGLE
    makeKnob(  "ANGLE_A_X",  30,  10, 11  );
    makeKnob(  "ANGLE_A_Y",  130, 10, 0  );
    makeKnob(  "ANGLE_A_Z",  230, 10, 0  );

    makeKnob(  "ANGLE_B_X",  30,  100, 0  );
    makeKnob(  "ANGLE_B_Y",  130, 100, 45  );
    makeKnob(  "ANGLE_B_Z",  230, 100, 0  );

    makeKnob(  "ANGLE_C_X",  30,  190, 0  );
    makeKnob(  "ANGLE_C_Y",  130, 190, 0  );
    makeKnob(  "ANGLE_C_Z",  230, 190, 77  );

//sliders
    cp5.addSlider("ITER")
        .plugTo(parent,"ITER")
        .setRange(1, 30)
        .setValue( 4 )
        .setPosition(10, 300)
        .setSize(250,10)
        .setId(1);
        ;


    cp5.addSlider("BRANCH_A_lenght")
        .plugTo(parent,"BRANCH_A")
        .setRange(1, 300)
        .setValue( 100 )
        .setPosition(10,340)
        .setSize(250,10)
        ;


    cp5.addSlider("BRANCH_B_lenght")
        .plugTo(parent,"BRANCH_B")
        .setRange(1, 300)
        .setValue( 100 )
        .setPosition(10,360)
        .setSize(250,10)
        ;


    cp5.addSlider("BRANCH_C_lenght")
        .plugTo(parent,"BRANCH_C")
        .setRange(1, 300)
        .setValue( 100 )
        .setPosition(10,380)
        .setSize(250,10)
        ;



  }

  public void draw() {
      background(abc);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  

  public void makeKnob( String type, int posX, int posY, int initValue  ) {

    cp5.addKnob( type )
                .plugTo(parent, type )
                .setRange(0,90)
                .setValue( initValue )
                .setPosition( posX,posY )
                .setRadius(30)
                .setDragDirection(Knob.VERTICAL)
                ;
  }

}

