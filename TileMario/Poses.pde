class Pose {
  private PVector w, g;
  //int state = 0;
  
  //protected Pose() {}
  
  public Pose(int x, int y) {
    g = new PVector(x, y);
    w = g2w(g);
  }
  
  public Pose(float x, float y) {
    w = new PVector(x, y);
    g = w2g(w);
  }
  
  public void set(int x, int y) {
    g = new PVector(x, y);
    w = g2w(g);
  }
  
  public void set(float x, float y) {
    w = new PVector(x, y);
    g = w2g(w);
  }
  
  //OPERATIONS
  public void add(PVector addend) {
    w.add(addend);
    g = w2g(w);
  }
  
  //CONVERSIONS
  private PVector g2w(PVector grid) {
    return PVector.mult(grid, GRID_SIZE);
  }
  
  public PVector s(Pose screen) {
    PVector q1 = PVector.sub(w, screen.w);
    //return new PVector(q1.x, GRID_SIZE*dim.tileGrid.h - q1.y);
    return new PVector(q1.x, height - q1.y);
  }
  
  public PVector gInt() {
    return new PVector(gIntX(), gIntY());
  }
  
  public int gIntX() {
    return min(max((int)(g.x), 0), dim.tileGrid.w-1);
  }
  
  public int gIntY() {
    return min(max(floor(g.y), 0), dim.tileGrid.h-1);
  }
  
  public PVector gSub() {
    return PVector.sub(g, gInt());
  }
  
  private PVector w2g(PVector world) {
    return PVector.div(world, GRID_SIZE);
  }
  
  //MISC
  public Pose copy() {
    return new Pose(w.x, w.y);
  }
  
  public PVector g() {return g;}
  public PVector w() {return w;}
}


public class LinkedPose extends Pose{
  private Pose pose;
  public LinkedPose(Pose p, int x, int y) {
    super(x, y);
    pose = p;
  }
  
  public LinkedPose(Pose p, float x, float y) {
    super(x, y);
    pose = p;
  }
  
  public PVector s(Pose screen) {
    PVector q1 = PVector.sub(super.w(), screen.w);
    //return new PVector(q1.x, GRID_SIZE*dim.tileGrid.h - q1.y);
    return new PVector(q1.x, height - q1.y);
  }
  
  public PVector gInt() {
    return new PVector(gIntX(), gIntY());
  }
  
  public int gIntX() {
    return min(max((int)(g().x), 0), dim.tileGrid.w-1);
  }
  
  public int gIntY() {
    return min(max((int)(g().y), 0), dim.tileGrid.h-1);
  }
  
  public PVector gSub() {
    return PVector.sub(super.g(), gInt());
  }
  
  public PVector g() {
    return PVector.add(pose.g(), super.g());
  }
  
  public PVector w() {
    return PVector.add(pose.w(), super.w());
  }
}
