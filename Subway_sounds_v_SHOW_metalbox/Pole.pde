class Pole { // Even though there are multiple objects, we still only need one class. No matter how many cookies we make, only one cookie cutter is needed.Isnâ€™t object-oriented programming swell?
  color c;
  float xpos;
  float ypos;
  float xspeed;
  int poleWidth;
  float zdepth;

  Pole(color tempC, float tempXpos, float tempYpos,int tempWidth, float tempXspeed, float tempZ) { // The Constructor is defined with arguments.
    c = tempC;
    xpos = tempXpos;
    ypos = tempYpos;
    poleWidth = tempWidth;  
    xspeed = tempXspeed;
    zdepth = tempZ;
  }

  void display() {
    stroke(0);
    fill(c);
    rectMode(CENTER);
    pushMatrix();
    translate(0, 0, zdepth);
    rect(xpos,ypos,poleWidth,height*2);
    popMatrix();
  }

  void move(float _speed) {
    xpos = xpos - _speed;
    if (xpos < -width-poleWidth/2) {
      xpos = width*2.75;
    }
  }
}
