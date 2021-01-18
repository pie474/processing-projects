class Player {
  int team;       //0 = blue     1 = red


  Cannon C;


  Player(int t) {
    C = new Cannon(25, 28, 0, 25, 7, 30, 15, 6);
    team = t;
    if (team == 0) {
      body = BLUE;
      outline = BLUEOUTLINE;
    } else if (team == 1) {
      body = RED;
      outline = REDOUTLINE;
    }
  }

  color body;
  color outline;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  PVector acc = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector pos = new PVector(fieldsize.x/2, fieldsize.y/2);
  int xdir = 0;
  int ydir = 0;

  float facing;
  int size = 60;
  int speed = 4;
  float acceleration = 0.2;
  int friction = -2;
  boolean firing = false;
  

  void show() {

    facing = atan2(mouseY-height/2, mouseX-width/2);

    for (Bullet part : bullets) {
      part.show();
    }
    C.show();

    //fill(75, 200, 255);
    fill(body);
    stroke(outline);
    strokeWeight(5);
    ellipse(pos.x + vel.x, pos.y + vel.y, size, size);
  }

  void update() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bull = bullets.get(i);
      bull.update();
      if (bull.actuallydead) {
        bullets.remove(i);
      }
    }
    

    if (xdir == -1) {
      if (vel.x > -speed) {
        vel.x -= acceleration;
      } else {
        vel.x = -speed;
      }
    } else if (xdir == 1) {
      if (vel.x < speed) {
        vel.x += acceleration;
      } else {
        vel.x = speed;
      }
    } else if (xdir == 0) {
      if (vel.x<-0.05) {
        vel.x += acceleration/4;
      } else if (vel.x > 0.05) {
        vel.x -=acceleration/4;
      } else {
        vel.x = 0;
      }
    }


    if (ydir == -1) {
      if (vel.y > -speed) {
        vel.y -= acceleration;
      } else {
        vel.y = -speed;
      }
    } else if (ydir == 1) {
      if (vel.y < speed) {
        vel.y += acceleration;
      } else {
        vel.y = speed;
      }
    } else if (ydir == 0) {
      if (vel.y < -0.05) {
        vel.y += acceleration/4;
      } else if (vel.y > 0.05) {
        vel.y -= acceleration/4;
      } else {
        vel.y = 0;
      }
    }


    pos.set(pos.x + vel.x, pos.y + vel.y);
    C.update();

    if (firing) {
      if (C.reloadcnt == 0) {
        C.fire();
      }
    }

    
    // constraining position to the field size
    if (pos.x<-fieldBorder+size/2) {
      pos.x = -fieldBorder+size/2;
      if (vel.x<0) {
        vel.x = 0;
      }
    }
    if (pos.x>fieldsize.x+fieldBorder-size/2) {
      pos.x = fieldsize.x+fieldBorder-size/2;
      if (vel.x>0) {
        vel.x = 0;
      }
    }
    if (pos.y<-fieldBorder+size/2) {
      pos.y = -fieldBorder+size/2;
      if (vel.y<0) {
        vel.y = 0;
      }
    }
    if (pos.y>fieldsize.y+fieldBorder-size/2) {
      pos.y = fieldsize.y+fieldBorder-size/2;
      if (vel.y>0) {
        vel.y = 0;
      }
    }
  }
}
