class TerrainTile extends Tile {
  public TerrainTile(Dimension d, int x, int y) {
    super(d, x, y);
    texPath = "grass";
  }
  
  public void init(TileGrid tileGrid) {
    texture = getTexture(loadBytes("sprites/tiles/"+texPath+".dat")[getBorders(tileGrid)], 12);
  }
    
  
  int getBorders(TileGrid tileGrid) {
    boolean l = false;
    boolean u = false;
    boolean r = false;
    boolean d = false;
    boolean bl = false;
    boolean br = false;
    boolean tl = false;
    boolean tr = false;
    
    boolean borderL = false;
    boolean borderU = false;
    boolean borderR = false;
    boolean borderD = false;
    
    
    if(pos.gIntX() == 0) {
      borderL = true;
      bl = true;
      l = true;
      tl = true;
    }
    if(pos.gIntX() == tileGrid.w-1) {
      borderR = true;
      br = true;
      r = true;
      tr = true;
    }
    if(pos.gIntY() == 0) {
      borderD = true;
      bl = false;
      d = false;
      br = false;
    }
    if(pos.gIntY() == tileGrid.h-1) {
      borderU = true;
      tl = false;
      u = false;
      tr = false;
    }
    if(!borderL) {
      if(tileGrid.tilesArray[pos.gIntX()-1][pos.gIntY()] instanceof TerrainTile) {
        l = true;
      }
    }
    if(!borderU) {
      if(tileGrid.tilesArray[pos.gIntX()][pos.gIntY()+1] instanceof TerrainTile) {
        u = true;
      }
    }
    if(!borderR) {
      if(tileGrid.tilesArray[pos.gIntX()+1][pos.gIntY()] instanceof TerrainTile) {
        r = true;
      }
    }
    if(!borderD) {
      if(tileGrid.tilesArray[pos.gIntX()][pos.gIntY()-1] instanceof TerrainTile) {
        d = true;
      }
    }
    if(!borderD && !borderL) {
      if(tileGrid.tilesArray[pos.gIntX()-1][pos.gIntY()-1] instanceof TerrainTile) {
        bl = true;
      }
    }
    
    if(!borderD && !borderR) {
      if(tileGrid.tilesArray[pos.gIntX()+1][pos.gIntY()-1] instanceof TerrainTile) {
        br = true;
      }
    }
    if(!borderU && !borderL) {
      if(tileGrid.tilesArray[pos.gIntX()-1][pos.gIntY()+1] instanceof TerrainTile) {
        tl = true;
      }
    }
    if(!borderU && !borderR) {
      if(tileGrid.tilesArray[pos.gIntX()+1][pos.gIntY()+1] instanceof TerrainTile) {
        tr = true;
      }
    }
    
    int v = 0;
    if(l) v+=1;
    if(u) v+=2;
    if(r) v+=4;
    if(d) v+=8;
    if(bl) v+=16;
    if(br) v+=32;
    if(tl) v+=64;
    if(tr) v+=128;
    
    return v;
  }
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=

class AirTile extends Tile {
  public AirTile(Dimension d, int x, int y) {
    super(d, x, y);
    texPath = "";
    collidable = false;
  }
  
  public void init(TileGrid t) {}
  
  public void show(Pose screenPos) {}
    
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=

class BrickTile extends Tile {
  public BrickTile(Dimension d, int x, int y) {
    super(d, x, y);
    state = new DefaultState();
    texPath = "brick";
  }
  
  void show(Pose screenPos) {
    if(collidable) super.show(screenPos);
  }
    
  public void collide(int dir, int power) {
    if(power > 0) {
      state.handleInput(this, dir);
    }
  }
  
  class DefaultState implements TileState {
    void handleInput(Tile tile, int col) {
      tile.collidable = false;
      tile.state = new BrokenState();
    }
  }
  
  class BrokenState implements TileState {
    void handleInput(Tile tile, int col) {}
  }
}


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=

class QuestionTile extends ContainerTile {
  public QuestionTile(Dimension d, int x, int y) {
    super(d, x, y);
    state = new DefaultState();
    texPath = "questionBox";
  }
  
  void show(Pose screenPos) {
    if(collidable) super.show(screenPos);
  }
      
  public boolean collision(PVector p) {return collidable;}
  
  public void collide(int dir, int power) {
    state.handleInput(this, dir);
  }
  
  class DefaultState implements TileState {
    void handleInput(Tile tile, int col) {
      texture = getTexture(1, 2);
      ContainerTile castedTile = (ContainerTile)tile;
      castedTile.produceContents();
      tile.state = new UsedState();
    }
  }
  
  class UsedState implements TileState {
    void handleInput(Tile tile, int col) {}
  }
}
