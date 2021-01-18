public abstract class PowerUp extends Entity {
  int direction = 1;
  float speed;
  
  public PowerUp(Dimension d, int startX, int startY, String texPath, float sp) {
    super(d, startX, startY, "powerups/" + texPath);
    speed = sp;
  }
  
  public PImage getRawFrame(PImage sheet, int frame) {
    return sheet.get(frame*16,0,16,16);
  }
  
  public void update() {
    vel.x = speed*direction;
    doPhysics();
    if(leftWall() || rightWall()) {
      direction *=-1;
    }
  }
  
  public boolean collisionEvent(Player p, int colDir) {return true;}
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public class Coin extends PowerUp {
  public Coin(Dimension d, int x, int y) {
    super(d, x, y, "coin", 0);
  }
  
  public void update() {}
  
  public boolean collisionEvent(Player p, int colDir) {
    return true;
  }
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public class RedMushroom extends PowerUp {
  public RedMushroom(Dimension d, int startX, int startY) {
    super(d, startX, startY, "redMushroom", 3);
  }
  
  
  public boolean collisionEvent(Player p, int colDir) {
    p.powerUpState = max(p.powerUpState, 1);
    return true;
  }
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public class GreenMushroom extends PowerUp {
  public GreenMushroom(Dimension d, int startX, int startY) {
    super(d, startX, startY, "greenMushroom", 3);
  }
  
  public boolean collisionEvent(Player p, int colDir) {
    p.LIVES++;
    return true;
  }
}
