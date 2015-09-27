import ddf.minim.*;
import ddf.minim.effects.*;
import processing.pdf.*;

PGraphicsPDF pdf;

Minim minim;
AudioInput in;
LowPassSP lpf;

int startingTime;
int finnishTime;
int y;

void setup()
{
  size(1024, 1000);
  background(0);
  frameRate(30);
  y=1;
  
  startingTime = millis();
  finnishTime = startingTime +  273000;
  
  pdf = (PGraphicsPDF)beginRecord(PDF, finnishTime+".pdf");
  beginRecord(pdf);

smooth();

  minim = new Minim(this);
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 1024);
  // make a low pass filter with a cutoff frequency of 200 Hz
  lpf = new LowPassSP(200, in.sampleRate());
  in.addEffect(lpf);
  println(in.sampleRate());
}

void draw()
{
  //
  if ( y == 0 ) {
    pdf.nextPage();
    background(0);
  }
  stroke(255);
  // draw the waveforms


  y = ((y+1)%height);

  for (int i = 0; i < in.bufferSize() - 1; i++)
  {
    //mono
    float soundSignal = in.mix.get(i);
    //filter small noises
    // between -0.3 and 0.3 because signal is neg and pos
    if ( soundSignal < .01 && soundSignal > -.01  ) {
      soundSignal=0;
      //soundSignal*=50;
    }
    else {
      //changes amplitude
      soundSignal*=100;
      line(i, soundSignal + y, i+1, soundSignal + y);
    }
    
  }


  //
  //for the 4"33 piece we should use 273 seconds
  //and the sampling is 44100hz with means 44100 samples a second
  //so the drawing should be 44100 * 273 
  //
  //12 039 300 samples
  //divided for the number of sample show per line 1024
  // 11 757 lines
  //
  //that way we could represent all the samples in the piece
  //11 757 horizontal lines
  //i draw 1000 lines every screen so i need 11.7 screens
  //
  //also 4"33 in mills 273 000 milliseconds
  
  //println(frameCount);
  //println(frameRate);
  if(frameCount >= 11757 ){
    finnishTime=millis();
    println( (((finnishTime-startingTime)/1000)) );
    endRecord();
    exit();
  }

}



void mousePressed() {
  endRecord();
  exit();
}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}

