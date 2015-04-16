
boolean displayChange = true;

int GRID_SIZE = 5;
int GRID_X = 160;
int GRID_Y = 140;

PImage masque;

ArrayList<Position> positions = new ArrayList<Position>();
ArrayList<PositionSomme> positionsSomme = new ArrayList<PositionSomme>();

Spacebrew sb;

void setup() {

  size(800, 700, P3D);
  background(255);
  masque = loadImage("../plan4.png");

  setupSpacebrew();
}

//création du masque pour n'afficher que les cubes qui sont dans le batiment
Boolean isNotMask (int x, int y) {
  color pixel = masque.get(x, y);
  int i = pixel;
  return i== 0;
}

void keyPressed() {
  switch(keyCode) {
  case 67 : // C -> CLEAN
    CleanInterface();
    CleanDisplay();
    break;
  default:
  //println(keyCode);
  }
}

void draw() {
  if(displayChange){
    Display();
  }
}

void Display() {
  background(255);
  /*for(PositionSomme ps : positionsSomme){
   fill(0,ps.positions.size()*10);
   noStroke();
   rect(ps.x*GRID_SIZE, ps.y*GRID_SIZE, GRID_SIZE, GRID_SIZE);
   }*/

  camera    (GRID_SIZE*GRID_X/2, GRID_SIZE*GRID_Y, 400, 
  GRID_SIZE*GRID_X/2, GRID_SIZE*GRID_Y/2, 0, 
  0.0, 1, 1.0);
  for (int i=0; i<=GRID_X; i++) {
    for (int j=0; j<=GRID_Y; j++) {
      if (isNotMask (i, j)) {
        for (int z=0; z<=5; z++) {
          for  (int Niveau=0 ; Niveau<4-PositionIteration(i, j); Niveau++) {
            pushMatrix();
            translate(i*GRID_SIZE, j*GRID_SIZE, Niveau*GRID_SIZE);
            box(GRID_SIZE);
            popMatrix();
          }
        }
      }
    }
  }
}

void CleanDisplay(){
  positions = new ArrayList<Position>();
  positionsSomme = new ArrayList<PositionSomme>();
 
}


void AddPosition(int x, int y, color c, int uid, int ts) {
  if (isNotMask(x, y)) {
    positions.add(new Position(x, y, c, uid, ts));
    CaluclePositionSommes();
  }
}

int PositionIteration(int x1, int y1) {

  for (int i=0; i<positionsSomme.size(); i++) {
    PositionSomme ps = positionsSomme.get(i);  
    if ((x1 == ps.x) && (y1==ps.y)) {
      return ps.positions.size();
    }
  }
  return 0;
}

void CaluclePositionSommes() {


  // calcule les sommes des positions
  for (Position p1 : positions) {
    if (!p1.dejaAdditionne) {
      for (PositionSomme ps : positionsSomme) {
        if (ps.x == p1.x && ps.y == p1.y) {
          if (!ps.userExist(p1)) {
            ps.ajoutePosition(p1);
            displayChange = true;
          }
          p1.dejaAdditionne = true;
        }
      }
      if (!p1.dejaAdditionne) {
        positionsSomme.add(new PositionSomme (p1));
        displayChange = true;
      }
      p1.dejaAdditionne = true;
    }
  }


 /* //
  class PositionSomme {
  int x=0;
  int y=0;
  ArrayList<Position> positions = new ArrayList<Position> ();


  PositionSomme (Position p) {  
    positions.add(p);
    x=p.x;
    y=p.y;
  }
  Boolean userExist(Position p) {
    for (Position pTest : positions) {
      if (p.user==pTest.user) {
        return true;
      }
    }
    return false;
  }
  void ajoutePosition(Position p) {
    positions.add(p);
  }

  JSONObject getJSON() {

    JSONObject json = new JSONObject();
    json.setInt("x", x);
    json.setInt("y", y);
    json.setInt("z", positions.size());
    return json;
  }
}
  
   if (keyPressed) {
    switch(key) {

    case 's' : 
      // enregistre les JSON

      // positons
      JSONArray jsonPositions = new JSONArray();
      int n=0;
      for (Position p : positions) {
        jsonPositions.setJSONObject(n, p.getJSON());
        n++;
      }
      saveJSONArray(jsonPositions, "data/positions.json");
      
      // croisements Somme
      JSONArray jsonPositionsSomme = new JSONArray();
      n=0;
      for (PositionSomme ps : positionsSomme) {
        jsonPositionsSomme.setJSONObject(n, ps.getJSON());
        n++;
      }
      saveJSONArray(jsonPositionsSomme, "data/positionsSomme.json");
      
      break;

    
    }
  }*/
}


