class Screen {
  Pose pos, trCorner, blBuffer, trBuffer;
  int bufferTiles = 1;
  PVector vel, acc, safeZone;
  final float frictionCoeff = 0.93; //technically 1-friction...
  
  public Screen(float x, float y, float sx, float sy) {
    pos = new Pose(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    safeZone = new PVector(sx, sy);
    trCorner = new LinkedPose(pos, (float)width, (float)height);
    blBuffer = new LinkedPose(pos, -bufferTiles, -bufferTiles);
    trBuffer = new LinkedPose(trCorner, bufferTiles, bufferTiles);
  }
  
  void track(Pose target) {
    //println(topDist() + " " + rightDist() + " " + bottomDist() + " " + leftDist());
    //noFill();
    //rect(width/2-safeZone.x, height/2-safeZone.y, 2*safeZone.x, 2*safeZone.y);
    PVector t = target.s(pos);
    
    float rDist = max(t.x - width/2 - safeZone.x, 0);
    float bDist = min(-t.y + height/2 + safeZone.y, 0);
    float tDist = max(-t.y + height/2 - safeZone.y, 0);
    float lDist = min(t.x - width/2 + safeZone.x, 0);
    //float xTrackForce = lDist + rDist;
    //float yTrackForce = bDist + tDist;
    PVector trackForce = new PVector(lDist + rDist, bDist + tDist);
    trackForce.mult(0.02);
    acc = trackForce;
    vel.add(acc);
    vel.mult(frictionCoeff);
    
    if(leftDist() <= 0) vel.x = max(vel.x, 0);
    if(rightDist() <= 0) vel.x = min(vel.x, 0);
    if(bottomDist() <= 0) vel.y = max(vel.y, 0);
    if(topDist() <= 0) vel.y = min(vel.y, 0);
    
    pos.add(vel);
    
    pos.set(min(max(pos.w.x, 0), (float)dim.tileGrid.w*GRID_SIZE-width-1), 
            min(max(pos.w.y, 0), (float)dim.tileGrid.h*GRID_SIZE-height));
    
  }
  
  boolean isSafe(PVector sP) {
    return ((sP.x-(width/2))<safeZone.x) && ((sP.y-(height/2))<safeZone.y);
  }
  
  float topDist() {
    return dim.tileGrid.h*GRID_SIZE - pos.w.y - height;
    //return -pos.y ;
  }
  
  float leftDist() {
    return pos.w.x;
  }
  
  float bottomDist() {
    return pos.w.y;
  }
  
  float rightDist() {
    return dim.tileGrid.w*GRID_SIZE - pos.w.x - width - GRID_SIZE - 1;
  }
}
