class ICamera {
  PVector pos, sensor, resolution, rot;
  Sphere target;
  
  
  PVector tl, tr, bl, br;
  
  ICamera(float x, float y, float z, Sphere t, float sx, float sy, float fd, int rx, int ry) {
    pos = new PVector(x, y, z);
    sensor = new PVector(sx, sy, fd);
    resolution = new PVector(rx, ry);
    target = t;
    
  }
  
  void calculateCorners() {
    updateRot();
    
    PVector a = rot;
    
    float sr = pythag(sensor.z, sensor.y/2);
    float cornerPitch = atan2(sensor.y/2, sensor.z);
    
    PVector right = new PVector(pos.x + (sensor.x/2)*cos(a.x + HALF_PI), pos.y + (sensor.x/2)*sin(a.x + HALF_PI), pos.z);
    PVector left = new PVector(pos.x - (sensor.x/2)*cos(a.x + HALF_PI), pos.y - (sensor.x/2)*sin(a.x + HALF_PI), pos.z);
    fill(255, 0, 0);
    
    tl = new PVector(left.x + sr*cos(a.y + cornerPitch)*cos(a.x), left.y + sr*cos(a.y + cornerPitch)*sin(a.x), left.z + sr*sin(a.y + cornerPitch)); 
    bl = new PVector(left.x + sr*cos(a.y - cornerPitch)*cos(a.x), left.y + sr*cos(a.y - cornerPitch)*sin(a.x), left.z + sr*sin(a.y - cornerPitch)); 
    tr = new PVector(right.x + sr*cos(a.y + cornerPitch)*cos(a.x), right.y + sr*cos(a.y + cornerPitch)*sin(a.x), right.z + sr*sin(a.y + cornerPitch)); 
    br = new PVector(right.x + sr*cos(a.y - cornerPitch)*cos(a.x), right.y + sr*cos(a.y - cornerPitch)*sin(a.x), right.z + sr*sin(a.y - cornerPitch)); 
    
  }
  
  
  void updateRot() {
    PVector sensorCenter = PVector.sub(target.getPos(), pos);    
     rot = angleOf(sensorCenter);
  }
  
  
  
  PImage render(Sphere s, Sphere light) {
    calculateCorners();
    
    PImage image = createImage((int)resolution.x, (int)resolution.y, ARGB);
    image.loadPixels();
    for(int j = 0; j<resolution.y; j++) {
      PVector lbound = PVector.lerp(tl, bl, (float)j/resolution.y);
      PVector rbound = PVector.lerp(tr, br, (float)j/resolution.y);
      
      for(int i = 0; i<resolution.x; i++) {
        PVector point = PVector.lerp(lbound, rbound, (float)i/resolution.x);
        
        Ray r = new Ray(pos, point, 50);
        
        color val = r.trace(s, light, false);
        
        image.pixels[j*(int)resolution.x + i] = val;
      }
    }
    image.updatePixels();
    return image;
  }
  
  color createRayAt(int x, int y) {
    calculateCorners();
    PVector lbound = PVector.lerp(tl, bl, y/resolution.y);
    PVector rbound = PVector.lerp(tr, br, y/resolution.y);
    
    PVector point = PVector.lerp(lbound, rbound, x/resolution.x);
    
    Ray r = new Ray(pos, point, 50);
        
    return r.trace(s, light, true);
  }
  
  void show(Sphere s, Sphere light) {
    calculateCorners();
    stroke(0, 128, 128);
    sphereAt(pos, 1);
    lineFromTo(pos, tl);
    lineFromTo(pos, tr);
    lineFromTo(pos, bl);
    lineFromTo(pos, br);
    lineFromTo(tl, tr);
    lineFromTo(tr, br);
    lineFromTo(br, bl);
    lineFromTo(bl, tl);
    PVector tle = PVector.add(PVector.mult(PVector.sub(tl, pos), 10), pos);
    PVector tre = PVector.add(PVector.mult(PVector.sub(tr, pos), 10), pos);
    PVector ble = PVector.add(PVector.mult(PVector.sub(bl, pos), 10), pos);
    PVector bre = PVector.add(PVector.mult(PVector.sub(br, pos), 10), pos);
    stroke(0, 100, 100);
    lineFromTo(pos, tle);
    lineFromTo(pos, tre);
    lineFromTo(pos, ble);
    lineFromTo(pos, bre);
    
    PVector lbound = PVector.lerp(tl, bl, mouseY/(float)height);
    PVector rbound = PVector.lerp(tr, br, mouseY/(float)height);
    
    sphereAt(lbound, 2);
    sphereAt(rbound, 2);
    
    PVector p = PVector.lerp(lbound, rbound, mouseX/(float)width);
    
    sphereAt(p, 1);
    
    Ray r = new Ray(pos, p, 200);
    r.trace(s, light, true);
  }
}
