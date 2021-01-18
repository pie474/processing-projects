class Sphere {
  private float radius;
  private PVector pos;
  private float transmission; //  0-1
  private float brightness;
  
  Sphere(float r, float x, float y, float z, float trans, float bri) {
    radius = r;
    pos = new PVector(x, y, z);
    transmission = trans;
    brightness = bri;
  }
  
  float getTransmission() {return transmission;}
  
  float getBrightness() {return brightness;}
  
  float getRadius() {return radius;}
  
  PVector getPos() {return pos;}
  
  void show() {    
    noFill();
    stroke(255);
    strokeWeight(1);
    sphereAt(pos, radius);
  }
}
