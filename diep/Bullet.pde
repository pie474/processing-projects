class Bullet {
  boolean dead = false;
  boolean actuallydead = false;
  int alpha = 360;
  int size, health, damage;
  int t = 0;
  PVector vel = new PVector(0, 0);
  PVector pos = new PVector(0, 0);
  
  Bullet(PVector position, float direction, int sp, int s, int h, int d) {
    pos.set(position.x,position.y);
    vel.set(cos(direction) * sp, sin(direction) * sp);
    size = s;
    health = h;
    damage = d;
  }
  
  void show() {
    fill(P.body, alpha);
    stroke(P.outline, alpha);
    strokeWeight(5);
    ellipse(pos.x,pos.y,size,size);
  }
  
  void update() {
    pos.set(pos.x+vel.x,pos.y+vel.y);
    t++;
    
    //collision
    for (int i = shapes.shapes.size() - 1; i >= 0; i--) {
      Shape shape = shapes.shapes.get(i);
      if(!dead) {
        if(dist(shape.pos.x,shape.pos.y,pos.x,pos.y) < (shape.s+size)/2) {
          shape.health-=constrain(damage,0,health);
          if(shape.health>0) {
            health = 0;
          } else {
            health-=damage;
          }
        }
      }
    }
    
    
    if(health <= 0) {
      dead = true;
    }
    
    if(t>100) {
      dead = true;
    }
    
    if(dead) {
      if(alpha<20) {
        actuallydead = true;
      } else {
        alpha -= 20;
      }
    }
  }
}
