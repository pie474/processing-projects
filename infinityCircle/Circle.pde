class Circle {
  private float radius;
  private PVector pos;
  private float transmission; //  0-1
  private float brightness;
  
  Circle(float r, float x, float y, float trans, float bri) {
    radius = r;
    pos = new PVector(x, y);
    transmission = trans;
    brightness = bri;
  }
  
  PVector[] intersect(Ray ray) {
    /*
    y=tan(ray.get(2)*(x - ray.get(0)) + ray.get(1)
    (x-pos.get(0))^2 + (y-pos.get(1))^2 = radius^2
    */
    
    PVector rayPos = ray.getPos();
    
    float a = rayPos.x;//350
    float b = rayPos.y;//250
    float c = rayPos.z;
    float d = pos.x;//350
    float e = pos.y - b;//100
    float f = radius;//100
    
    float x1 = -cos(c)*(sqrt(sq(cos(c))*(sq(d)-sq(e))+2*sin(c)*cos(c)*d*e-sq(d)+sq(f))-cos(c)*d-sin(c)*e);
    float x2 =  cos(c)*(sqrt(sq(cos(c))*(sq(d)-sq(e))+2*sin(c)*cos(c)*d*e-sq(d)+sq(f))+cos(c)*d+sin(c)*e);
    //-cos(c)*(sqrt(sq(cos(c))*(sq(350)-sq(100))+2*sin(c)*cos(c)*350*100-sq(350)+sq(100))-cos(c)*350-sin(c)*100)
    //-cos(c)*(sqrt(sq(cos(c))*112500+sin(2c)*35000-112500)-cos(c)*350-sin(c)*100)
    //(364*sin(arctan(3.5)))  c=0
    //350  c=pi
    
    
    float y1 = tan(c)*(x1) + b;
    float y2 = tan(c)*(x2) + b;
    
    PVector[] points = new PVector[2];
    points[0] = new PVector(x1, y1);
    points[1] = new PVector(x2, y2);

    return points;
  }
  
  float getTransmission() {
    return transmission;
  }
  
  float getBrightness() {
    return brightness;
  }
  
  float getRadius() {
    return radius;
  }
  
  
  float sq(float x) {return x*x;}
  
  PVector getPos() {return pos;}
  
  void show() {
    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(pos.x, pos.y, 2*radius, 2*radius);
  }
}
