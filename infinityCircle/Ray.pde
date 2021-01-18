class Ray {
  int maxBounces;
  PVector pos;
  
  Ray(float x, float y, float a, int b) {
    pos = new PVector(x, y, a);
    maxBounces = b;
  }
  
  PVector getPos() {
    return pos;
  }
  
  float rayTrace(Circle c, Circle light) {
    for(int i = 1; i<=maxBounces; i++) {
      PVector[] points = intersect(light);
      if(points != null) {
        float dist0 = sqrt((points[0].x-pos.x)*(points[0].x-pos.x) + (points[0].y-pos.y)*(points[0].y-pos.y));
        float dist1 = sqrt((points[1].x-pos.x)*(points[1].x-pos.x) + (points[1].y-pos.y)*(points[1].y-pos.y));
        
        int farthest = 1;
        if(dist1 > dist0) {farthest = 0;}
        
        PVector bouncePoint = points[farthest];
        
        
        //stroke(200);
        //fill(200);
        //ellipse(bouncePoint.x, bouncePoint.y, 5, 5);
        
        stroke(100);
        line(pos.x, pos.y, bouncePoint.x, bouncePoint.y);
        
        
        float finalBrightness = light.getBrightness() * pow(c.getTransmission(), i);
        return finalBrightness;
      }
      bounce(c);
    }
    return 0;
  }
  
  PVector[] intersect(Circle c) {
    float r = c.radius;
    float lx1 = pos.x - c.getPos().x;
    float ly1 = pos.y - c.getPos().y;
    float lx2 = lx1 + 10*cos(pos.z);
    float ly2 = ly1 + 10*sin(pos.z);
    
    float d_x = lx2-lx1;
    float d_y = ly2-ly1;
    float d_r = sqrt(d_x*d_x + d_y*d_y);
    float D = lx1*ly2 - lx2*ly1;
    float disc = r*r*d_r*d_r-D*D;
    
    if(disc<0) {
      return null;
    } else {
    
      float x1 = (D*d_y+sgn(d_y)*d_x*sqrt(disc))/(d_r*d_r) + c.getPos().x;
      float x2 = (D*d_y-sgn(d_y)*d_x*sqrt(disc))/(d_r*d_r) + c.getPos().x;
      
      float y1 = (-D*d_x+abs(d_y)*sqrt(disc))/(d_r*d_r) + c.getPos().y;
      float y2 = (-D*d_x-abs(d_y)*sqrt(disc))/(d_r*d_r) + c.getPos().y;
      
      PVector[] points = new PVector[2];
      points[0] = new PVector(x1, y1);
      points[1] = new PVector(x2, y2);
      
      return points;
    }
  }
  
  void bounce(Circle c) {
    PVector[] points = intersect(c);
    
    if(points == null) {
      return;
    }
    
    //stroke(255);
    //fill(255);
    //ellipse(points[0].x, points[0].y, 5, 5);
    //ellipse(points[1].x, points[1].y, 5, 5);
    
    float dist0 = sqrt((points[0].x-pos.x)*(points[0].x-pos.x) + (points[0].y-pos.y)*(points[0].y-pos.y));
    float dist1 = sqrt((points[1].x-pos.x)*(points[1].x-pos.x) + (points[1].y-pos.y)*(points[1].y-pos.y));
    
    int farthest = 0;
    if(dist0 == 0) {farthest = 1;}
    else if(dist1 > dist0) {farthest = 1;}
    
    PVector bouncePoint = points[farthest];
    
    
    //stroke(200);
    //fill(200);
    //ellipse(bouncePoint.x, bouncePoint.y, 5, 5);
    
    stroke(200);
    line(pos.x, pos.y, bouncePoint.x, bouncePoint.y);
    
    float pointAngle = atan2(bouncePoint.y-c.getPos().x, bouncePoint.x-c.getPos().x);
    float bounceAngle = 2*pointAngle - pos.z + PI;
    
   
    pos.set(bouncePoint.x, bouncePoint.y, bounceAngle);    
  }
  
  void showOrigin() {
    fill(255);
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  int sgn(float x) {
    if(x<0) {return -1;}
    else {return 1;}
  }
  
}
