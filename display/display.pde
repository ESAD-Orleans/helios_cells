boolean displayChange = true;
		boolean drapeau;



		int GRID_SIZE = 5;
		int GRID_X = 160;
		int GRID_Y = 140;
		
		int CAMERA_Y = 0;
		int CAMERA_Z = -250;

		PImage masque;

		ArrayList<Position> positions = new ArrayList<Position>();
		ArrayList<PositionSomme> positionsSomme = new ArrayList<PositionSomme>();

		Spacebrew sb;
		boolean sketchFullScreen() {
		return true;
		}

		void setup() {


		size(displayWidth, displayHeight, P3D);
		background(255);
		masque = loadImage("../plan4.png");

		drapeau = false;

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
		
  case 37 : // <- 
  CAMERA_Y +=10;
  break;  
  case 38 : // UP 
  CAMERA_Z +=10;
  break;  
  case 39 : // -> 
  CAMERA_Y -=10;
  break;  
  case 40 : // DOWN 
  CAMERA_Z -=10;
  break; 
		
		case 67 : // C -> CLEAN
		CleanInterface();
		CleanDisplay();
		break;
		default:
		//println(keyCode);
		}
		}

		void draw() {
		int d = day();
		int m = month();
		int y = year();
		int h = hour();
		int min = minute();

		if (minute() == 0) {
		if (!drapeau) {
		JSONArray jsonPositionsSomme = new JSONArray();
		int n=0;
		for (PositionSomme ps : positionsSomme) {
		jsonPositionsSomme.setJSONObject(n, ps.getJSON());
		n++;
		}
		saveJSONArray(jsonPositionsSomme, "data/positionsomme" + d + "-" + m + "-" + y + "-" + "à" + "-" + h + "h"+ min + "min" + ".json");
		drapeau = true;
		}
		} else {
		drapeau = false;
		}

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

		camera    (
			0, CAMERA_Y, CAMERA_Z,
			0, 0, 0,
			0.0, 1, 1.0
		);
		for (int i=0; i<=GRID_X; i++) {
		for (int j=0; j<=GRID_Y; j++) {
		if (isNotMask (i, j)) {
		for (int z=0; z<=5; z++) {
		for  (int Niveau=0 ; Niveau<4-PositionIteration(i, j); Niveau++) {
		pushMatrix();
		// ici la valeur /1.6 décentre un peu (la valeur réelement centrale est /2)
            	translate(i*GRID_SIZE-GRID_SIZE*GRID_X/2, j*GRID_SIZE-GRID_SIZE*GRID_Y/1.6, Niveau*GRID_SIZE);
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

		//
		}


      
