import java.util.*;

final int GRID_SIZE = 64;
final int PIXEL_SIZE = 4;
final float GRAVITY = -0.85;

HashSet<Character> INPUTS;

Dimension dim;

void setup() {
  fullScreen();
  background(29);
  PImage loading = loadImage("sprites/loading.png");
  image(loading, width/2 - loading.width/2, height/2 - loading.height/2);
  colorMode(RGB);
  
  INPUTS = new HashSet<Character>();
  
  dim = new Dimension(1, 1);
  dim.init();
}

void draw() {
  background(147,206,255);
  dim.update();
}

void keyPressed() {  
  if(!INPUTS.contains(key)) {
    INPUTS.add(key);
  }
}

void keyReleased() {
  if(INPUTS.contains(key)) {
    INPUTS.remove(key);
  }
}
