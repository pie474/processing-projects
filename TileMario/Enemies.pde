public abstract class Enemy extends Entity {
  int direction;
  float speed;
  public Enemy(Dimension d, int startX, int startY, String texPath, int dir, float sp) {
    super(d, startX, startY, "enemies/" + texPath);
    direction = dir;
    speed = abs(sp);
  }
  
  public void update() {
    vel.x = speed*direction;
    doPhysics();
    if(leftWall() || rightWall()) {
      direction *=-1;
    }
  }
  
  public boolean collisionEvent(Player p, int colDir) {
    if(colDir == 2) {
      p.vel.y = 8;
      return true;
    }
    return false;
  }
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public class Goomba extends Enemy {
  public Goomba(Dimension d, int startX, int startY, int dir) {
    super(d, startX, startY, "goomba", dir, 2.5);
  }
  
  public PImage getRawFrame(PImage sheet, int frame) {
    return sheet.get(frame*17,0,16,16);
  }
  

}
