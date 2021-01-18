public class Player extends Entity {
  State state;
  public int powerUpState = 0, LIVES = 5;
  final float maxXVel = 8;
  

  public Player(Dimension d, int startX, int startY) {
    super(d, startX, startY, "player/small");
    state = new StandingState();
  }
  
  public PImage getRawFrame(PImage sheet, int frame) {
    return sheet.get(frame*13,0,12,15);
  }
  
  public void update() {
    pos.add(vel);
    state.handleInput(this, INPUTS);
    vel.add(acc);
    if(!INPUTS.contains('a') && !INPUTS.contains('d')) vel.x *= 0.7;
    vel.x = min(vel.x, maxXVel);
    vel.x = max(vel.x, -maxXVel);
    
    vel.y = min(vel.y, maxYVel);
    vel.y = max(vel.y, -maxYVel);
    //pos.add(vel);
    
    if(onGround()) {
      acc.y = 0;
      vel.y = max(0, vel.y);
      
      do {
        pos.add(new PVector(0, 1));
      } while(onGround());
      pos.add(new PVector(0, -1));
      
    } else {
      acc.y = GRAVITY;
    }
        
    if(headBump()) {
      vel.y = min(vel.y, 0);
      dimension.tileGrid.tilesArray[tl.gIntX()][tl.gIntY()].collide(3, powerUpState);
      dimension.tileGrid.tilesArray[tr.gIntX()][tr.gIntY()].collide(3, powerUpState);
      
      do {
        pos.add(new PVector(0, -1));
      } while(headBump());
      pos.add(new PVector(0, 1));
    }
    
    if(leftWall()) {
      vel.x = max(vel.x, 0);
      acc.x = max(acc.x, 0);
      do {
        pos.add(new PVector(1, 0));
      } while(leftWall());
      pos.add(new PVector(-1, 0));
      
    }
    
    if(rightWall()) {
      vel.x = min(vel.x, 0);
      acc.x = min(acc.x, 0);
      do {
        pos.add(new PVector(-1, 0));
      } while(rightWall());
      pos.add(new PVector(1, 0));
      
    }
  }
  
  public boolean leftWall() {
    return super.leftWall() || pos.w().x<0;
  }
  
  public boolean collide(Player p) {return false;}
}


interface State {
  void handleInput(Player m, HashSet<Character> inps);
}

class StandingState implements State {
  void handleInput(Player m, HashSet<Character> inps) {
    if(inps.contains('w')) {
      m.state = new JumpingState();
    }
    
    if(!m.onGround()) {
      m.state = new MidAirState();
    }
    
    if(INPUTS.contains('d')) {
      m.acc.x = 0.5;
    } else if(INPUTS.contains('a')) {
      m.acc.x = -0.5;
    } else {
      m.acc.x = 0;
    }
  }
}

class JumpingState implements State {
  long startMillis;
  JumpingState() {startMillis = millis();}
  void handleInput(Player m, HashSet<Character> inps) {
    if(!inps.contains('w') || millis() - startMillis > 250 || m.headBump()) {
      m.state = new MidAirState();
    }
    m.vel.y = 10;
    if(INPUTS.contains('d')) {
      m.acc.x = 0.5;
    } else if(INPUTS.contains('a')) {
      m.acc.x = -0.5;
    } else {
      m.acc.x = 0;
    }
  }
}

class MidAirState implements State {
  void handleInput(Player m, HashSet<Character> inps) {
    if(m.onGround()) {
      m.state = new StandingState();
    }
    
    if(INPUTS.contains('d')) {
      m.acc.x = 0.5;
    } else if(INPUTS.contains('a')) {
      m.acc.x = -0.5;
    } else {
      m.acc.x = 0;
    }
  }
}

class DuckingState implements State {
  void handleInput(Player m, HashSet<Character> inps) {
    if(INPUTS.contains('d')) {
      m.acc.x = 3;
    } else if(INPUTS.contains('a')) {
      m.acc.x = -3;
    } else {
      m.acc.x = 0;
    }
  }
}

class GroundPoundState implements State {
  void handleInput(Player m, HashSet<Character> inps) {
    
  }
}
