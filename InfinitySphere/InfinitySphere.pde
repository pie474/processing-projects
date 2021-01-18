Sphere s, light;
ICamera c;

PImage render;
void setup() {
  size(700, 700, P3D);
  
  colorMode(RGB);
  
  s = new Sphere(100, 0, 0, 0, 0.95, 0);
  light = new Sphere(15, 0, 80, 0, 1, 255);
  
  c = new ICamera(-200, 0, 0, s, 17.5, 3, 15, 17500, 3000);
}

void draw() {
  background(0);
  PVector cam = pointFromAng(new PVector(mouseX/100.0, mouseY/100.0), s.getRadius()+350.0);
  camera(cam.x, cam.y, cam.z, 0, 0, 0, 0, 0, -1);
  
  light.show();
  s.show();
  c.show(s, light);
  
  
  strokeWeight(3);
  stroke(255, 0, 0);
  line(0, 0, 0, 50, 0, 0);//x axis
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 50, 0);//y axis
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 50);//z axis 
}

void mouseClicked() {
  println("Rendering.......................");
  int time = millis();
  render = c.render(s, light);
  render.save("render.png");
  time = millis() - time;
  println("Render Time: " + (int)(time/60000.0) + " minutes, " + (((int)(time/1000.0))%60) + " seconds, " + (time%1000) + " millis");
  exit();
}

void sphereAt(PVector pos, float r) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  sphere(r);
  popMatrix();
}

void lineFromTo(PVector a, PVector b) {
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

PVector angleOf(PVector p) {
  return new PVector(atan2(p.y, p.x), atan2(p.z, pythag(p.x, p.y)));
}

PVector angleFrom(PVector a, PVector b) {
  return angleOf(PVector.sub(b, a));
}

PVector pointFromAng(PVector a, float r) {
  float xyrad = r*cos(a.y);
  return new PVector(xyrad*cos(a.x), xyrad*sin(a.x), r*sin(a.y));
}

float pythag(float a, float b, float c) {
  return sqrt(sqr(a)+sqr(b)+sqr(c));
}

float pythag(float a, float b) {
  return sqrt(sqr(a)+sqr(b));
}

float sqr(float x) {return x*x;}
