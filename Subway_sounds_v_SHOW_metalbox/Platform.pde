class platform {
  color tileColor;
  float xpos, ypos, zpos;
  float xspeed;
  int tileScale;
  int counter;

  platform (color _Color, float _Xpos, float _Ypos, int _tileScale, float _xspeed, float _z) { // The Constructor is defined with arguments.
    tileColor = _Color;
    xpos = _Xpos;
    ypos = _Ypos;
    tileScale = _tileScale;  
    xspeed = _xspeed;
    zpos = _z;
    counter = 4;
  }

  void display() {
    int numTile_row = int(width/tileScale);
    int numTile_columm = int(height/tileScale);    

    for (int r= 0; r< numTile_row; r++) {
      for (int c= 0; c< numTile_columm; c++) {
        pushMatrix();
        translate(0, 0, zpos);
        if (c >= numTile_columm/4 && c < numTile_columm/4+12) {
          if (counter % 3 == 0) {
            stroke(80);
            fill(245);
          }
          else {
            noStroke();
            fill(30);
          }
        }
        else if (c%2==0 && r%2==0) {
          if (counter % 3 == 0) {
            stroke(80);
            fill(tileColor);
          }
          else {
            noStroke();
            fill(30);
          }
        } 
        else {
          if (counter % 3 == 0) {
            stroke(80);
            fill(230, 160, 0);
          }
          else {
            noStroke();
            fill(30);
          }
        }
        rect(xpos+r*tileScale, ypos+c*tileScale, tileScale, tileScale);
        popMatrix();
      }
    }
  }

  void move(float _speed) {
    xpos = xpos - _speed;
    if (xpos < -width*2.5) {
      xpos = width*3;
      counter++;
    }
  }
}

