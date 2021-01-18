class Ray {
  int maxBounces;
  PVector pos, dir;
  
  Ray(float x, float y, float z, float dx, float dy, float dz, int b) {
    pos = new PVector(x, y, z);
    dir = new PVector(dx, dy, dz);
    maxBounces = b;
  }
  
  Ray(PVector p, PVector d, int b) {
    pos = p.copy();
    dir = PVector.sub(d, p);
    maxBounces = b;
  }
  
  PVector getPos() {return pos;}
  
  color trace(Sphere s, Sphere light, boolean show) {
    for(int i = 1; i<=maxBounces; i++) {
      PVector[] points = intersect(light, false);
      if(points != null) {
        float dist0 = sqrt(sq(points[0].x-pos.x) + sq(points[0].y-pos.y) + sq(points[0].z-pos.z));
        float dist1 = sqrt(sq(points[1].x-pos.x) + sq(points[1].y-pos.y) + sq(points[1].z-pos.z));
        
        int nearest = 1;
        if(dist1 > dist0) {nearest = 0;}
        
        PVector bouncePoint = points[nearest];
        
        
        if(show) {
          stroke(100);
          lineFromTo(pos, bouncePoint);
        }
        
        
        float finalBrightness = light.getBrightness() * pow(s.getTransmission(), i);
        return color(finalBrightness/4, finalBrightness, finalBrightness, 255);
      }
      boolean result = bounce(s, 255, show);
      if(!result) {
        return color(0, 0, 0, 0);
      }
    }
    return color(0, 0, 0, 255);
  }

  
  boolean bounce(Sphere s, int shade, boolean show) {
    PVector[] points = intersect(s, false);
    
    if(points == null) {
      return false;
    }
    
    
    float dist0 = sqrt(sq(points[0].x-pos.x) + sq(points[0].y-pos.y) + sq(points[0].z-pos.z));
    float dist1 = sqrt(sq(points[1].x-pos.x) + sq(points[1].y-pos.y) + sq(points[1].z-pos.z));
    
    int farthest = 0;
    if(dist0 == 0) {farthest = 1;}
    else if(dist1 > dist0) {farthest = 1;}
    
    PVector bouncePoint = points[farthest];
    //println(bouncePoint);

    if(show) {
      stroke(shade);
      strokeWeight(3);
      lineFromTo(pos, bouncePoint);
    }

    
    PVector bounceNormal = PVector.sub(s.getPos(), bouncePoint);
    bounceNormal = PVector.div(bounceNormal, bounceNormal.mag());//normalizes it
    
    PVector bounceAngle = PVector.sub(dir, PVector.mult(bounceNormal, 2*PVector.dot(dir, bounceNormal)));
       
    pos.set(bouncePoint);
    dir.set(bounceAngle);
    return true;
  }
  

  PVector[] intersect(Sphere s, Boolean show) {
    PVector p1 = pos;
    PVector p2 = PVector.add(pos, dir);
    //p2 = PVector.add(p1, p2);
    PVector p3 = s.getPos();
    float r = s.getRadius();
    
    float a = sq(p2.x-p1.x) + sq(p2.y-p1.y) + sq(p2.z-p1.z);
    float b = 2*((p2.x-p1.x)*(p1.x-p3.x) + (p2.y-p1.y)*(p1.y-p3.y) + (p2.z-p1.z)*(p1.z-p3.z));
    float c = sq(p1.x) + sq(p1.y) + sq(p1.z) + sq(p3.x) + sq(p3.y) + sq(p3.z) - 2*(p1.x*p3.x + p1.y*p3.y + p1.z*p3.z) - sq(r);
    
    float disc = sq(b) - 4*a*c;
    
    if(disc < 0) {
      
      return null;
    } else {
      
      float u1 = (b*-1 + sqrt(disc)) / (2*a);
      float u2 = (b*-1 - sqrt(disc)) / (2*a);
      
      PVector[] points = new PVector[2];
      points[0] = new PVector(p1.x + u1*(p2.x - p1.x), p1.y + u1*(p2.y - p1.y), p1.z + u1*(p2.z - p1.z));
      points[1] = new PVector(p1.x + u2*(p2.x - p1.x), p1.y + u2*(p2.y - p1.y), p1.z + u2*(p2.z - p1.z));
      
      if(show) {
        stroke(255);
        fill(255);
        sphereAt(points[0], 3);
        sphereAt(points[1], 3);
      }
      
      return points;
    }
  }
  
  void showOrigin(float shade) {
    stroke(shade);
    fill(shade);
    sphereAt(pos, 5);
    sphereAt(PVector.add(pos, dir), 5);
  }
  
  int sgn(float x) {
    if(x<0) {return -1;}
    else {return 1;}
  }
  
}
