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


    // description : a slider is either used horizontally or vertically.
    //               width is bigger, you get a horizontal slider
    //               height is bigger, you get a vertical slider.  
    // parameters  : name, minimum, maximum, default value (float), x, y, width, height
    cp5.addSlider("abc")
      .setRange(0, 255)
        .setPosition(10, 10);

    // create a toggle and change the default look to a (on/off) switch look
    cp5.addToggle("field")
      .plugTo(parent, "vector")
        .setPosition(10, 30)
          .setSize(20, 20)
            .setValue(true);

    cp5.addToggle("P_field")
      .plugTo(parent, "perpendicular")
        .setPosition(50, 30)
          .setSize(20, 20)
            .setValue(true);

    cp5.addToggle("BG_img")
      .plugTo(parent, "backgroundImage")
        .setPosition(90, 30)
          .setSize(20, 20)
            .setValue(false);

    cp5.addToggle("debug_img")
      .plugTo(parent, "fieldImg")
        .setPosition(130, 30)
          .setSize(20, 20)
            .setValue(true);


    //    cp5.addSlider("cellsize")
    //      //conect to class variable
    //      .plugTo(parent, "cellsize")
    //        .setRange(4, 20)
    //          .setPosition(10, 130)
    //            .setValue(10);

    cp5.addSlider("blurAmout")
      .plugTo(parent, "blurAmout")
        .setRange(1, 5)
          .setPosition(10, 80)
            .setValue(1);


    cp5.addSlider("vectorIntencity")
      .plugTo(field, "vectorIntencity")
        .setRange(0, 255)
          .setPosition(10, 120)
            .setValue(100);

    cp5.addSlider("vectorMultiplier")
      .plugTo(field, "vectorMultiplier")
        .setRange(-50, 50)
          .setPosition(10, 140)
            .setValue(10);

    cp5.addSlider("n_vehicles")
      .plugTo(parent, "n_vehicles")
        .setRange(10, 5000)
          .setPosition(10, 160)
            .setValue(100);
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
}

