class Shapes {
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  
  Shapes() {
    for(int i = 0;i<50;i++) {         //squares
      float r = random(0,2*PI);
      shapes.add(new Shape(4, int(random(0,fieldsize.x)),int(random(0,fieldsize.y)),r,r,0.15));
    }
    
    for(int i = 0;i<30;i++) {         //triangles
      float r = random(0,2*PI);
      shapes.add(new Shape(3, int(random(0,fieldsize.x)),int(random(0,fieldsize.y)),r,r,0.15));
    }
    
    for(int i = 0;i<10;i++) {         //pentagons
      float r = random(0,2*PI);
      shapes.add(new Shape(5, int(random(0,fieldsize.x)),int(random(0,fieldsize.y)),r,r,0.15));
    }
    
  }
  
  void show() {
    for (int i = shapes.size() - 1; i>=0; i--) {
      Shape shape = shapes.get(i);
      if(!shape.dead) {
        shape.update();
        shape.show();
      } else {
        shapes.remove(i);
      }
    }
  }
}

//--------------------------------------------------------------------------------

class Shape {
  int s;
  int sides;
  float speed;
  PVector pos = new PVector();
  PVector vel = new PVector();
  float rotation, direction;
  float rotationspeed = 0.005;
  int maxHealth, health;
  float healthBarCo;
  color outline, fill;
  
  boolean dead = false;
  
  Shape(int si, int posx, int posy, float dir, float movedir, float sp) {
    pos.set(posx,posy);
    rotation = dir;
    direction = movedir;
    speed = sp;
    sides = si;
    vel.set(cos(direction)*speed, sin(direction)*speed);
    if (int(random(0,2)) == 1) {
      rotationspeed *= -1;
    }
    if(si == 4) {
      s = 28;
      maxHealth = 10;
      fill = SQUAREFILL;
      outline = SQUAREOUTLINE;
      healthBarCo = 4;
    } else if(si == 3) {
      s = 27;
      maxHealth = 25;
      fill = TRIANGLEFILL;
      outline = TRIANGLEOUTLINE;
      healthBarCo = 1.5;
    } else if(si == 5) {
      s = 35;
      maxHealth = 65;
      fill = PENTAGONFILL;
      outline = PENTAGONOUTLINE;
      healthBarCo = 0.65;
    }
    health = maxHealth;
  }
  
  void show() {
    if(pos.x<P.pos.x+width/2+rendermargin && pos.x>P.pos.x-width/2-rendermargin  &&  pos.y<P.pos.y+height/2+rendermargin && pos.y>P.pos.y-height/2-rendermargin) {
      stroke(outline);
      strokeWeight(5);
      fill(fill);
      pushMatrix();
      translate(pos.x,pos.y);
      rotate(rotation);
      
      beginShape();
      for (float i = 0; i< 2*PI; i+= 2*PI/sides) {
        vertex(cos(i)*s, sin(i)*s);
      }
      endShape(CLOSE);
      popMatrix();
      
      //health bar
      
      if(health<maxHealth) {
        stroke(HEALTHBACKGROUND);
        strokeWeight(10);
        line(pos.x-20,pos.y+40, pos.x-20+maxHealth*healthBarCo, pos.y+40);
        
        stroke(HEALTH);
        strokeWeight(5);
        line(pos.x-20,pos.y+40, pos.x-20+health*healthBarCo, pos.y+40);
      }
    }
  }
  
  void update() {
    rotation  += rotationspeed;
    rotation %= 2*PI;
    
    if(speed>0.15) {
      speed -= 0.01;
    }
    
    vel.set(cos(direction)*speed, sin(direction)*speed);
    pos.set(pos.x+vel.x,pos.y+vel.y);
    
    for (int i = shapes.shapes.size() - 1; i >= 0; i--) {
      Shape shape = shapes.shapes.get(i);
      if(shape == this) continue;
      if(!dead) {
        if(dist(shape.pos.x,shape.pos.y,pos.x,pos.y) < s+shape.s) {
          
            
          PVector diff = PVector.sub(shape.pos, pos);
          float atan2 = atan2(diff.y,diff.x);
          
          shape.direction = atan2;
          shape.speed = 0.9;
          
          direction = atan2+PI;
          speed = 0.9;
          break;
        }
      }
    }
    
    
    
    if(health <= 0) {
      dead = true;
    }
  }
}
