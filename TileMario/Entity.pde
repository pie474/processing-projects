public abstract class Entity {
  Dimension dimension;
  Pose pos;
  PVector vel, acc;
  float maxYVel = 22;
  
  LinkedPose bl, br, tl, tr, lb, lt, rb, rt;
  final int hitBoxWidth, hitBoxHeight;
  protected PImage texture;
  protected String texPath;
  
  private boolean loaded = false;
  
  public Entity(Dimension d, int startX, int startY, String tP) {
    dimension = d;
    pos = new Pose(startX, startY);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    texPath = "sprites/entities/" + tP + ".png";
    
    PImage raw = getRawFrame(loadImage(texPath), 0);
    texture = createImage(raw.width*4,raw.height*4,ARGB);
    for(int i = 0; i < texture.width; i++) {
      for(int j = 0; j < texture.height; j++) {
        int i2 = i/4;
        int j2 = j/4;
        color col = raw.pixels[j2*raw.width+i2];
        texture.pixels[j*texture.width+i] = col;
      }
    }
    hitBoxWidth = texture.width;
    hitBoxHeight = texture.height;
    
    bl = new LinkedPose(pos, (float)2*PIXEL_SIZE, 0f);
    br = new LinkedPose(pos, (float)hitBoxWidth - 2*PIXEL_SIZE, 0f);
    tl = new LinkedPose(pos, (float)2*PIXEL_SIZE, (float)hitBoxHeight);
    tr = new LinkedPose(pos, (float)hitBoxWidth - 2*PIXEL_SIZE, (float)hitBoxHeight);
    lb = new LinkedPose(pos, 0f, (float)2*PIXEL_SIZE);
    lt = new LinkedPose(pos, 0f, (float)hitBoxHeight-2*PIXEL_SIZE);
    rb = new LinkedPose(pos, (float)hitBoxWidth, (float)2*PIXEL_SIZE);
    rt = new LinkedPose(pos, (float)hitBoxWidth, (float)hitBoxHeight-2*PIXEL_SIZE);
  }
  
  abstract PImage getRawFrame(PImage sheet, int frame);
  
  public void show(Screen screen) {
    image(texture, pos.s(screen.pos).x, pos.s(screen.pos).y - texture.height);
  }
  
  abstract void update();
  
  public void doPhysics() {
    ////////////////state.handleInput(this, INPUTS);
    
    //if(!INPUTS.contains('a') && !INPUTS.contains('d')) vel.x *= 0.7;
    //vel.x = min(vel.x, props.maxXVel);
    //vel.x = max(vel.x, -props.maxXVel);
    pos.add(vel);
    vel.add(acc);
    vel.y = min(vel.y, maxYVel);
    vel.y = max(vel.y, -maxYVel);
    
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
  
  boolean onGround() {
    return dimension.tileGrid.collision(bl) || dimension.tileGrid.collision(br);
  }
  
  boolean leftWall() {
    return dimension.tileGrid.collision(lb) || dimension.tileGrid.collision(lt);
  }
  
  boolean rightWall() {
    return dimension.tileGrid.collision(rb) || dimension.tileGrid.collision(rt);
  }
  
  boolean headBump() {
    return dimension.tileGrid.collision(tl) || dimension.tileGrid.collision(tr);
  }
  
  boolean loaded(Screen screen) {
    loaded |= onScreen(screen);
    return loaded;
  }
  boolean onScreen(Screen screen) {
    PVector sPos = pos.s(screen.pos);
    return sPos.x>=-texture.width && sPos.x<=width && sPos.y>=-texture.height && sPos.y<height;
  }
  
  public boolean collision(Pose point) {
    return point.w().x<rb.w().x && point.w().y<tr.w().y && point.w().x>lb.w().x && point.w().y>br.w().y;
  }
  
  public int collision(Entity e) {
    if(e.collision(bl) || e.collision(br)) {
      return 2;
    }
    if(e.collision(tl) || e.collision(tr)) {
      return 0;
    }
    if(e.collision(lb) || e.collision(lt)) {
      return 3;
    }
    if(e.collision(rb) || e.collision(rt)) {
      return 1;
    }
    return -1;
  }
  
  public boolean collide(Player p) {
    int c = p.collision(this);
    if(c != -1) {
      return collisionEvent(p, c);
    }
    return false;
  }
  
  public boolean collisionEvent(Player p, int colDir) {return false;}
}
