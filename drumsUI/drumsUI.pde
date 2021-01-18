import themidibus.*;
import processing.serial.*;
import javafx.util.Pair;
//kick, left drum, mid drum, right drum, right cymbal, pedal press, open left cymbal, closed left cymbal
// 0        1         2           3           4             5              6                   7

//WARNING: BADLY WRITTEN CODE BELOW



//YOU HAVE BEEN WARNED
Serial port;
MidiBus midi;

int[] drums;
int[] layout;
boolean[] toggled;
JSONArray configsJSON;
JSONObject configs;
JSONObject configuration;
int configurationInd = 0;
HashMap<String, Integer> drumTypes;
HashMap<Integer, String> reverseDrumTypes;
ArrayList<ArrayList<Pair<Integer, String>>> categories;

int typesPerColumn = 22;

boolean clickRegistered = false;
int assignState = 0; //0 = needs to click on drum,  1 = needs to click on new type
int drumToAssign = 0;

void setup() {
  size(900,500);
  rectMode(CENTER);
  
  port = new Serial(this, Serial.list()[1], 31250);
  MidiBus.list();
  println();
  printArray(Serial.list());
  midi = new MidiBus(this, 0, -1);
  drums = new int[7];
  
  configsJSON = loadJSONArray("configs.json");
  setConfig(0);
  
  
  drumTypes = new HashMap<String, Integer>();
  reverseDrumTypes = new HashMap<Integer, String>();
  
  JSONArray types = loadJSONArray("midi_values.json");
  categories = new ArrayList<ArrayList<Pair<Integer, String>>>();
  for (int i = 0; i < types.size(); i++) {
    JSONArray cat = types.getJSONObject(i).getJSONArray("drums");
    ArrayList<Pair<Integer, String>> catArr = new ArrayList<Pair<Integer, String>>();
    for(int j = 0; j<cat.size(); j++) {
      JSONObject type = cat.getJSONObject(j);
      int value = type.getInt("value");
      String name = type.getString("name");
      drumTypes.put(name, value);
      reverseDrumTypes.put(value, name);
      catArr.add(new Pair(value, name));
    }
    categories.add(catArr);
  }
  
  
  //port.write("initialized");
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(2);
  
  
  fill(map(drums[0], 0, 127, 0, 255));
  ellipse(200, 265, 150, 50);
  
  fill(map(drums[1], 0, 127, 0, 255));
  ellipse(70, 200, 100, 100);
  
  fill(map(drums[2], 0, 127, 0, 255));
  ellipse(200, 170, 100, 100);
  
  fill(map(drums[3], 0, 127, 0, 255));
  ellipse(330, 200, 100, 100);
  
  fill(map(drums[4], 0, 127, 0, 255));
  ellipse(300, 90, 70, 70);
  
  fill(map(drums[5], 0, 127, 0, 255));
  rect(70, 290, 24, 48);
  
  fill(map(drums[6], 0, 127, 0, 255));
  ellipse(100, 90, 70, 70);
  if(drums[5] == 0) {
    ellipse(100, 70, 70, 70);
  }
  
  fill(255);
  textAlign(CENTER, CENTER);
  
  
  drumClicked(200, 265, 150, 40, 0);
  drumClicked(70, 200, 100, 40, 1);
  drumClicked(200, 170, 100, 40, 2);
  drumClicked(330, 200, 100, 40, 3);
  drumClicked(300, 90, 70, 40, 4);
  drumClicked(70, 334, 70, 40, 5);
  drumClicked(100, 20, 120, 40, 6);
  drumClicked(100, 135, 120, 40, 7);
  
  
  if(assignState == 1) {
    fill(100);
    noStroke();
    switch(drumToAssign) {
      case 0:
        ellipse(200, 265, 130, 30);
        break;
      case 1:
        ellipse(70, 200, 80, 80);
        break;
      case 2:
        ellipse(200, 170, 80, 80);
        break;
      case 3:
        ellipse(330, 200, 80, 80);
        break;
      case 4:
        ellipse(300, 90, 50, 50);
        break;
      case 5:
        rect(70, 334, 60, 30);
        break;
      case 6:
        rect(100, 20, 110, 30);
        break;
      case 7:
        rect(100, 135, 110, 30);
        break;
    }
    fill(255);
  }
  
  text(reverseDrumTypes.get(layout[0]), 200, 265, 150, 40);
  text(reverseDrumTypes.get(layout[1]), 70, 200, 100, 40);
  text(reverseDrumTypes.get(layout[2]), 200, 170, 100, 40);
  text(reverseDrumTypes.get(layout[3]), 330, 200, 100, 40);
  text(reverseDrumTypes.get(layout[4]), 300, 90, 70, 40);
  text(reverseDrumTypes.get(layout[5]), 70, 334, 70, 40);
  if(drums[5]==127) {
    fill(75);
  }
  text(reverseDrumTypes.get(layout[6]), 100, 20, 120, 40);
  fill(255);
  if(drums[5]==0) {
    fill(75);
  }
  text(reverseDrumTypes.get(layout[7]), 100, 135, 120, 40);
  
  fill(255);
  
  int counter = 0, catCounter = 0;
  for(ArrayList<Pair<Integer, String>> c : categories) {
    for(Pair<Integer, String> p : c) {
      if(catCounter%2 == 1) {
        fill(50);
        noStroke();
        rect(475+150*(counter/typesPerColumn), 20*(counter%typesPerColumn+1), 120, 20);
      }
      if(mouseX > 400 && mouseIn(475+150*(counter/typesPerColumn), 20*(counter%typesPerColumn+1), 120, 20)) {
        fill(150);
        noStroke();
        rect(475+150*(counter/typesPerColumn), 20*(counter%typesPerColumn+1), 120, 20);
        fill(255);
        if(mousePressed && !clickRegistered) {
          clickRegistered = true;
          if(assignState == 1) {
            layout[drumToAssign] = p.getKey();
            assignState = 0;
            sendLayout(layout);
          } else {
            
          }
        }
      }
      fill(255);
      text(p.getValue(), 475+150*(counter/typesPerColumn), 20*(counter%typesPerColumn+1), 120, 20);
      counter++;
    }
    catCounter++;
  }
  
  for(int i = 0; i<7; i++) {
    if(i!=5) drums[i] = max(0, drums[i]-1);
  }
  
  
  
  for(int i = 0; i<configsJSON.size(); i++) {
    fill(50);
    if(mouseIn(50 + 80*i, 400, 75, 40) && assignState == 0) {
      fill(100);
      if(mousePressed && !clickRegistered) {
        clickRegistered = true;
        fill(150);
        setConfig(i);
      }
    }
    noStroke();
    rect(50 + 80*i, 400, 75, 40);
    fill(255);
    text(configsJSON.getJSONObject(i).getString("name"), 50 + 80*i, 390, 75, 20);
    text("(" + configsJSON.getJSONObject(i).getString("key")+ ")", 50 + 80*i, 407, 75, 20);
  }
  
  if(port.readString() != null) println(port.readString());
}

void setConfig(int ind) {
  configurationInd = ind;
  configuration = configsJSON.getJSONObject(ind);
  layout = configuration.getJSONArray("main").getIntArray();
  sendLayout(layout);
  toggled = new boolean[8];
}

void noteOn(int channel, int pitch, int velocity) {
  for(int i = 0; i<layout.length; i++) {
    if(layout[i] == pitch) {
      drums[min(6, i)] = velocity;
    }
  }
}

void noteOff(int channel, int pitch, int velocity) {
  if(pitch == layout[5]) {
    drums[5] = 0;
  }
}

boolean mouseIn(float x, float y, float w, float h) {
  return (mouseX < x+w/2) && (mouseX > x-w/2) && (mouseY < y+h/2) && (mouseY > y-h/2);
}

void doDrumStuff(int i, float x, float y, float elpsW, float elpsH, float clickW, float clickH) {
  stroke(255);
  strokeWeight(2);
  
  fill(map(drums[0], 0, 127, 0, 255));
  ellipse(200, 265, 150, 50);
  
  drumClicked(200, 265, 150, 40, 0);
  
  if(assignState == 1 && drumToAssign == i) {
    fill(100);
    noStroke();
    rect(200, 265, 150, 40);
    fill(255);
  }
  
  text(reverseDrumTypes.get(layout[0]), 200, 265, 150, 40);
}

void drumClicked(float x, float y, float w, float h, int ind) {
  if(mouseIn(x, y, w, h)) {
    fill(50);
    noStroke();
    rect(x, y, w, h);
    fill(255);
    if(mousePressed && !clickRegistered) {
      clickRegistered = true;
      if(assignState == 0) {
        drumToAssign = ind;
        assignState++;
      } else {
        assignState = 0;
      }
    }
  }
}

void keyPressed() {
  switch(key) {
    case 'q':
      toggleDrum(6);
      toggleDrum(7);
      break;
    case 'e':
      toggleDrum(4);
      break;
    case 'a':
      toggleDrum(1);
      break;
    case 's':
      toggleDrum(2);
      break;
    case 'd':
      toggleDrum(3);
      break;
    case 'x':
      toggleDrum(0);
      break;
    case 'z':
      toggleDrum(5);
      break;
    default:
      for(int i = 0; i<configsJSON.size(); i++) {
        if(key==configsJSON.getJSONObject(i).getString("key").charAt(0)) {
          setConfig(i);
        }
      }
      break;
  }
}

void keyReleased() {
  if(key == 'z') {
    drums[5] = 0;
  }
}

void mouseReleased() {
  clickRegistered = false;
}

void mousePressed() {
  
}

void toggleDrum(int i) {
  int[] toggles = configuration.getJSONArray("toggles").getIntArray();
  int[] main = configuration.getJSONArray("main").getIntArray();
  if(toggles[i] != -1) {    
    toggled[i] = !toggled[i];
    if(toggled[i]) {
      layout[i] = toggles[i];
    } else {
      layout[i] = main[i];
    }
  }
  sendLayout(layout);
}

void sendLayout(int[] layout) {
  StringBuilder message = new StringBuilder("$");
  for(int i = 0; i<layout.length; i++) {
    char d = (char)(32+layout[i]);
    message.append(String.valueOf(d));
  }
  port.write(message.toString());
  println(message.toString());
}

void previewDrum(int note) {
  port.write("$" + (char)(32+note));
  println("$" + (char)(32+note));
}
  
