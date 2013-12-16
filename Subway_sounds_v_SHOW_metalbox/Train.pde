class A_train {
  PImage[] people = new PImage[24];
  PImage[] car = new PImage[18];
  PImage carEnd,carEnd2;
  float ytrans, yoff;

  A_train() {
    for (int i =0; i < people.length; i++) {
      people[i] = loadImage( "Data/subway_" + String.format("%02d", i+18) +".png"); //format to 2 zero name convetion
    }
    for (int i =0; i < car.length; i++) {
      car[i]= loadImage ("subway_slice.png");
    }
    carEnd = loadImage("subway_slice_end.png");
    carEnd2 = loadImage("subway_slice_end_02.png");
    ytrans = 1;
    yoff = 0;
  }

  void display () {
    for (int i = 0; i < people.length ; i++) {
      pushMatrix();
      translate(-460, ytrans, -i);
      switch(i)
      {
      case 0: 
        image(people[i], i*100+20, 400, 90, 120);
        break;
        case 1: 
        image(people[i], i*100+20, 380, 90, 120);
        break;
      case 2:
        image(people[i], i*100, 400, 110, 147);
        break;
      case 3:
             pushMatrix();
        translate(0, 0, 3);
        image(people[i], i*100, 400, 110, 147);
        popMatrix();
        break;
      case 4:
        pushMatrix();
        translate(0, 0, 5);
        image(people[i], i*100-25, 400, 110, 147);
        popMatrix();
        break;
      case 5:
        image(people[i], i*100+20, 400, 90, 120);
        break;
      case 6:
        image(people[i], i*100+20, 400, 90, 120);
        break;  
      case 7:
        image(people[i], i*100+40, 400, 110, 147);
        break;
      case 8:
        pushMatrix();
        translate(0, 0, 2);
        image(people[i], i*100+20, 400, 110, 147);
        popMatrix();
        break;
      case 9:
        pushMatrix();
        translate(0, 0, 4);
        image(people[i], i*100, 390, 110, 147);
        popMatrix();
        break;
      case 10:
        pushMatrix();
        translate(0, 0, 6);
        image(people[i], i*100-20, 400, 110, 147);
        popMatrix();
        break;
      case 12:
        image(people[i], i*100, 400, 110, 147);
        break;
      case 13:
        image(people[i], i*100, 400, 110, 147);
        break;
      case 14:
        image(people[i], i*100, 400, 110, 147);
        break;
      case 15:
        image(people[i], i*100+30, 400, 110, 147);
        break;
      case 16:
        pushMatrix();
        translate(0, 0, 3);
        image(people[i], i*100, 400, 110, 147);
        popMatrix();
        break;
      case 18:
        image(people[i], i*100+10, 390, 110, 147);
        break;
      case 19:
        image(people[i], i*100+10, 400, 110, 147);
        break;       
      case 20:
        image(people[i], i*100+20, 400, 110, 147);
        break;
      case 21:
        image(people[i], i*100+40, 380, 110, 147);
        break; 
      case 22:
        pushMatrix();
        translate(-5,-5,3);
        image(people[i], i*100+10, 390, 110, 147);
        popMatrix();
        break; 
      case 23:
        pushMatrix();
        translate(0,0,5);
        image(people[i], i*100, 400, 110, 147);
        popMatrix();
        break; 
        default:             
        image(people[i], i*100, 380, 110, 147);
      }
      popMatrix();
    }

    for (int i = 0; i< car.length; i++) {
      ytrans = noise(yoff)*10;
      constrain(ytrans,-8,3);
      yoff += .005;
      pushMatrix();
      translate(-width/2, ytrans, 10);
      image(carEnd,-65,250);
      image(carEnd2,width*2+230,250);
      image(car[i], i*155, 250);
      popMatrix();
    }
  }
  
}

