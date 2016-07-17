PShader shader;
float feed = 0.0367;
float kill = 0.0649;
float delta = 1.0;
float dA = 0.5;
float dB = 1.0;
 
 
void setup() {
  size(640, 360, P2D);
  shader = loadShader("teste.glsl"); 
  shader.set("screen", float(width), float(height));
  shader.set("delta", delta);
  shader.set("feed", feed);
  shader.set("kill", kill);
  shader.set("dA", dA);
  shader.set("dB", dB);
}
 
void draw() {
  shader.set("mouse", float(mouseX), float(height-mouseY));
  filter(shader);  
  
  if (keyPressed) {
    shader.set("dA", map (mouseX, 0, width, 0.001,  1 ));
    shader.set("dB", map (mouseY, 0, height, 0.001,  1 ));
   println(map (mouseX, 0, width, 0.001, 1 )+ " " + map (mouseY, 0, height, 0.001, 1 ) );
  }
 
}