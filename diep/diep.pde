color BACKGROUND;
color BACKGROUNDGRID;
color DARKBACKGROUND;
color DARKBACKGROUNDGRID;
color GRID;

color BLUE;
color BLUEOUTLINE;

color RED;
color REDOUTLINE;

color CANNONFILL;
color CANNONOUTLINE;

color SQUAREFILL;
color SQUAREOUTLINE;

color TRIANGLEFILL;
color TRIANGLEOUTLINE;

color PENTAGONFILL;
color PENTAGONOUTLINE;

color HEALTH;
color HEALTHBACKGROUND;
//--=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=--=-==-=-=-==-==-=-=-=-=-=-=-=-=-=-==-==-=-=-=-=-=-=-=-=-=-=-=-=-

Player P;
Shapes shapes;

int rendermargin = 50;
PVector fieldsize = new PVector(2000,2000);
int fieldBorder = 250;
int gridSize = 30;

void setup() {
  fullScreen();
  smooth();
  frameRate(60);
  translate(width/2, height/2);
  colorMode(HSB, 360,100,100);
  
  //--=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=--=-==-=-=-==-==-=-=-=-=-=-=-=-=-=-==-==-=-=-=-=-=-=-=-=-=-=-=-=-
  BACKGROUND = color(0,0,80);
  BACKGROUNDGRID = color(0,0,75);
  DARKBACKGROUND = color(0,0,72);
  DARKBACKGROUNDGRID = color(0,0,67);
  GRID = color(0,0,0,15);
  
  BLUE = color(193,100,88);
  BLUEOUTLINE = color(193,100,66);
  
  RED = color(358,68,95);
  REDOUTLINE = color(358,68,71);
  
  CANNONFILL = color(0,0,60);
  CANNONOUTLINE = color(0,0,45);
  
  SQUAREFILL = color(51,59,100);
  SQUAREOUTLINE = color(51,59,75);
  
  TRIANGLEFILL = color(360,53,99);
  TRIANGLEOUTLINE = color(359,53,74);
  
  PENTAGONFILL = color(230,53,99);
  PENTAGONOUTLINE = color(230,53,74);
  
  HEALTH = color(115,45,89);
  HEALTHBACKGROUND = color(0,0,33);
  //--=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=--=-==-=-=-==-==-=-=-=-=-=-=-=-=-=-==-==-=-=-=-=-=-=-=-=-=-=-=-=-
  
  P = new Player(0);
  shapes = new Shapes();
}

void draw() {
  translate(width/2-P.pos.x,height/2-P.pos.y);
  
  //background
  background(DARKBACKGROUND);
  noStroke();
  fill(BACKGROUND);
  rect(0,0,fieldsize.x,fieldsize.y);
  
  //grid lines
  stroke(BACKGROUNDGRID);
  strokeWeight(3);
  for(float i = floor((P.pos.x-width/2)/gridSize)*gridSize; i < P.pos.x+width/2; i+=gridSize) {
    line(i, P.pos.y-height/2, i, P.pos.y+height/2);
  }
  for(float i = floor((P.pos.y-height/2)/gridSize)*gridSize; i < P.pos.y+height/2; i+=gridSize) {
    line(P.pos.x-width/2, i, P.pos.x+width/2, i);
  }
  
  
  shapes.show();
  
  P.update();
  P.show();
  
  //text(P.pos.x, P.pos.x-width/2+30,P.pos.y-height/2+30);
  //text(P.pos.y, P.pos.x-width/2+30,P.pos.y-height/2+60);
}

void keyPressed() {
  if (key != CODED) {
    if (key == 'a') {
      P.xdir = -1;
    }
    if (key == 'd') {
      P.xdir = 1;
    }
    if (key == 'w') {
      P.ydir = -1;
    }
    if (key == 's') {
      P.ydir = 1;
    }
    
    if (key == ' ') {
      P.firing = true;
    }
  }
}


void keyReleased() {
  if(key != CODED) {
    if (key == 'a') {
      P.xdir = 0;
    }
    if (key == 'd') {
      P.xdir = 0;
    }
    if (key == 'w') {
      P.ydir = 0;
    }
    if (key == 's') {
      P.ydir = 0;
    }
    
    if (key == ' ') {
      P.firing = false;
    }
  }
}


void mousePressed() {
  if(mouseButton == LEFT) {
    P.firing = true;
  }
}


void mouseReleased() {
  if(mouseButton == LEFT) {
    P.firing = false;
  }
}
