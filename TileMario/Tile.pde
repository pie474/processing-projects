abstract class Tile {
  protected Pose pos;
  protected PImage texture;
  protected String texPath;
  protected TileState state;
  protected int gx, gy;

  //PROPERTIES
  protected float friction = 1;
  protected boolean collidable = true;
  

  Tile(Dimension d, int gx, int gy) {
    pos = new Pose(gx, gy);
    state = new DefaultState();
    this.gx = gx;
    this.gy = gy;
  }

  void init(TileGrid t) {
    texture = getTexture(0, 1);
  }

  public void collide(int dir, int power) {
  }

  void show(Pose screenPos) {
    image(texture, pos.s(screenPos).x, pos.s(screenPos).y - GRID_SIZE);
  }

  public boolean collision(PVector p) {
    return collidable;
  }





  PImage getTexture(int p, int wid) {
    PImage texsheet = loadImage("sprites/tiles/"+texPath+".png");
    texsheet.loadPixels();

    int px = p % wid;
    int py = p / wid;
    PImage temp = texsheet.get(px*16 + px, py*16 + py, 16, 16);


    PImage scaled = createImage(64, 64, ARGB);

    for (int i = 0; i < scaled.width; i++) {
      for (int j = 0; j < scaled.height; j++) {
        int i2 = i/4;
        int j2 = j/4;
        color col = temp.pixels[j2*temp.width+i2];
        scaled.pixels[j*scaled.width+i] = col;
      }
    }
    return(scaled);
  }

  protected class DefaultState implements TileState {
    void handleInput(Tile tile, int col) {
    }
  }
}




public abstract class ContainerTile extends Tile {
  protected Entity contents;
  protected Dimension dim;

  public ContainerTile(Dimension d, int x, int y) {
    super(d, x, y);
    dim = d;
    getContents();
  }
  
  public void getContents() {
    //String[] level = loadStrings("Worlds/1/1/E.txt");
    
    Table data = loadTable("Worlds/1/1/tileData.csv", "header");
    for(TableRow row : data.rows()) {
      int x = row.getInt("x");
      int y = row.getInt("y");
      if(x!= gx || y!= gy) continue;      
      switch(row.getString("type").charAt(0)) {
        case 'M':
          contents = new RedMushroom(dim, gx, gy+1);
          break;
        case 'G':
          contents = new GreenMushroom(dim, gx, gy+1);
          break;
        default:
          contents = new RedMushroom(dim, gx, gy+1);
      }
      return;
    }
    contents = new GreenMushroom(dim, gx, gy+1);
  }
  
  public void produceContents() {
    //getContents();
    dim.entities.add(contents);
  }

  public abstract void collide(int dir, int power);
}




public interface TileState {
  void handleInput(Tile tile, int col);
}
