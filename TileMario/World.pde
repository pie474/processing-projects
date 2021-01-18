class TileGrid {
  
  Tile[][] tilesArray;
  int w, h;
  
  
  TileGrid(Dimension d, int wor, int lev) {
    String[] level = loadStrings("Worlds/" + wor + "/" + lev + "/structure.txt");
    
    w = level[0].length();
    h = level.length;
    tilesArray = new Tile[w][h];
    
    for (int i = 0; i < w; i++) {
      for (int j = h-1; j >= 0; j--) {
        tilesArray[i][j] = createTile(d, level[h-j-1].charAt(i), i, j);
      }
    }
  }
  
  void init() {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        tilesArray[i][j].init(this);
      }
    }
  }
  
  void update(Screen screen) {
    PVector bl = screen.blBuffer.gInt();
    PVector tr = screen.trBuffer.gInt();
    for (int i = (int)bl.x; i < (int)tr.x; i++) {
      for (int j = (int)bl.y; j < (int)tr.y; j++) {
        tilesArray[i][j].show(screen.pos);
      }
    }
  }
  
  void updateAll(Screen screen) {
    for(int i = 0; i<w; i++) {
      for(int j = 0; j<h; j++) {
        tilesArray[i][j].show(screen.pos);
      }
    }
  }
  
  public boolean collision(Pose p) {
    return tilesArray[p.gIntX()][p.gIntY()].collision(p.gSub());
  }
  
}
  
public Tile createTile(Dimension d, char type, int x, int y) {
  switch(type) {
    case '#':
      return new TerrainTile(d, x, y);
    case 'H':
      return new BrickTile(d, x, y);
    case '?':
      return new QuestionTile(d, x, y);
    default:
      return new AirTile(d, x, y);
  }
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public class Dimension {
  TileGrid tileGrid;
  HashSet<Entity> entities, onScreen;
  Player player;
  Screen screen;
  int world, level;
  
  public Dimension(int wor, int lev) {
    entities = new HashSet<Entity>();
    onScreen = new HashSet<Entity>();
    world = wor;
    level = lev;
    screen = new Screen(0, 500, 300, 200);
  }
  
  public void init() {
    tileGrid = new TileGrid(this, world, level);
    tileGrid.init();
    player = new Player(this, 1, 15);
    entities.add(new Goomba(this, 20, 13, -1));
    //entities.add(new Coin(this, 15, 17));
    
    String[] data = loadStrings("Worlds/" + world + "/" + level + "/structure.txt");
    
    int w = data[0].length();
    int h = data.length;
    
    for (int i = 0; i < w; i++) {
      for (int j = h-1; j >= 0; j--) {
        switch(data[h-j-1].charAt(i)) {
          case 'C':
            entities.add(new Coin(this, i, j));
        }
      }
    }
  }
  
  public void update() {
    
    for(Entity e : entities) {
      if(e.loaded(screen)) {
        e.update();
        if(e.onScreen(screen)) {
          if(!onScreen.contains(e)) onScreen.add(e);
        } else {
          if(onScreen.contains(e)) onScreen.remove(e);
        }
      }
    }
    
    player.update();
    player.show(screen);
    
    for(Iterator<Entity> i = onScreen.iterator(); i.hasNext();) {
      Entity e = i.next();
      if(e.collide(player)) {
        kill(e);
        i.remove();
      }
      e.show(screen);
    }
    
    tileGrid.update(screen);
    
    
    screen.track(player.pos);
  }
  
  public void kill(Entity e) {
    if(entities.contains(e)) entities.remove(e);
  }
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public class Level {
  Dimension overworld, underground, activeDimension;
  Player player;
  public int COINS = 0;
  
  public Level(int wor, int lev) {
    
    overworld = new Dimension(wor, lev);
    activeDimension = overworld;
    //player = new Player();
  }
  
  public void init() {
    overworld.init();
  }
}
