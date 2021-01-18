//all PVectors are (x, y, rot)

Circle c, light;
float[] image;

void setup() {
  size(700, 700);
  
  c = new Circle(100, width/2, height/2, 0.75, 0);
  light = new Circle(5, c.getPos().x, c.getPos().y-50, 1, 255);
  
  ellipseMode(CENTER);
  
  
  
  
  
  image = new float[height];
  
  for(int i = 1; i <= height; i ++) {
    background(0);
    Ray r = new Ray(40, height/2, atan2(map(i, 1, height, c.getPos().y - c.getRadius(), 
        c.getPos().y + c.getRadius()) - height/2, c.getPos().x - 40), 50);
    //PVector[] points = c.intersect(r);
    //fill(255);
    r.showOrigin();
    c.show();
    light.show();
    
    float col = r.rayTrace(c, light);
    stroke(col);
    fill(col);
    rect(0, 0, 100, 100);
    
    image[i-1] = col;
  }
  
  //for(int i = 1; i <= height; i++) {
  //  strokeWeight(1);
  //  stroke((int)image[i-1]);
  //  line(1, i, 30, i); 
  //}
}

void draw() {
  background(0);
  for(int i = 1; i <= height; i++) {
    strokeWeight(1);
    stroke((int)image[i-1]);
    line(1, i, 30, i); 
  }
  
  
  Ray r = new Ray(40, height/2, atan2(mouseY - height/2, mouseX - 40), 50);
  
  stroke(255);
  float h = (c.getPos().x - r.getPos().x)*tan(r.getPos().z) + r.getPos().y;
  float ref = map(h, c.getPos().y - c.getRadius(), c.getPos().y + c.getRadius(), 1, height);
  line(31, ref, 37, ref);
  
  //PVector[] points = c.intersect(r);
  //fill(255);
  r.showOrigin();
  c.show();
  light.show();
  
  r.rayTrace(c, light);
  
  
}
  
