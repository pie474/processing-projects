class Cannon {
  int w;
  int l;
  int bsize;
  int bspeed;
  int reload;
  int bhealth, bdamage;
  float dir;
  float dirOffset = 0;
  PVector pos = new PVector();  //pos of tip of cannon
  PVector recoil = new PVector();
  
  Cannon(int wide, int len, float doffset, int bsi, int bsp, int relode, int bh, int bd) {
    w = wide;
    l = len;
    bsize = bsi;
    bspeed = bsp;
    reload = relode;
    dirOffset = doffset;
    bhealth = bh;
    bdamage = bd;
  }
  
  int reloadcnt = reload;
  
  void show() {
    fill(CANNONFILL); 
    stroke(CANNONOUTLINE);
    strokeWeight(5);
    pushMatrix();
    translate(P.pos.x + P.vel.x, P.pos.y + P.vel.y);
    rotate(dir);
    rect(P.size/2, -w/2, l, w);
    popMatrix();
  }
  
  void update() {
    this.pos.set(P.pos.x + cos(P.facing) * (l+P.size/2), P.pos.y + sin(P.facing) * (l+P.size/2));
    dir = P.facing + dirOffset;
    if(reloadcnt > 0) {
      reloadcnt--;
    }
  }
  
  void fire() {
    recoil.set(cos(dir+PI) * bsize/20, sin(dir+PI) * bsize/20);
    
    P.bullets.add(new Bullet(pos,dir,bspeed,bsize,bhealth, bdamage));
    
    P.vel.set(P.vel.x + recoil.x, P.vel.y + recoil.y);
    reloadcnt = reload;
  }
}
