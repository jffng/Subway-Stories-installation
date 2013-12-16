import oscP5.*;
import netP5.*;
import processing.serial.*;     // import the Processing serial library
Serial myPort;// The serial port


// OSC object + location of local computer
OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage X, Z;

// Train variables
A_train a; 
float zPos, xPos;
float speed = 25;
float zoom, speedInc, xFactor;

// Camera object
Cam cam;
PVector forward, backward, closeF, closeB;
// Background & foreground
Pole frontPoles[] = new Pole[8];
Pole midPoles[] = new Pole[8];
Pole backPoles[] = new Pole[8];
platform ground[] = new platform [5];

void setup() {
  size(1280, 720, P3D);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, 3*height/5, 0, 0, 1, 0);

  oscP5 = new OscP5(this, 8080);
  myRemoteLocation = new NetAddress("127.0.0.1", 8080);  

  zPos = 30;
  xPos = width/2;
  a = new A_train();
  forward = new PVector(0.2, 0);
  backward = new PVector(-0.2, 0);
  cam = new Cam(width/2);

  // Initialize the background tiles
  for (int i=0;i<ground.length;i++) {
    ground[i] = new platform (color(236, 186, 0), width*i, -20, 25, speed/3, -50);
  }

  // Initialize poles
  for (int i=0;i<frontPoles.length;i++) {
    frontPoles[i] = new Pole(color(0, 0, 80), i*600, height/2-20, 155, speed, 20);
  }
  for (int i=0;i<midPoles.length;i++) {
    midPoles[i] = new Pole(color(0, 0, 30), 100+i*500, height/2-20, 140, speed/1.7, -40);
  }
  for (int i=0;i<backPoles.length;i++) {
    backPoles[i] = new Pole(color(0, 0, 0), 160+i*700, height/2-20, 120, speed/2, -45);
  }
  println(Serial.list());

  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

void draw() {
  X = new OscMessage( "/x" );
  Z = new OscMessage( "/z" );

  float oldZ = zPos;
  float oldX = xPos;

  background(30);
  for (int i=0;i<ground.length;i++) {
    ground[i].move(speed/2.5);
    ground[i].display();
  }
  for (int i=0;i<backPoles.length;i++) {
    backPoles[i].move(speed/2);
    backPoles[i].display();
  }

  fill(0);
  pushMatrix();
  translate(0, 0, -25);
  rectMode(CORNER);
  rect(-width, -height/2, width*4, height/2);
  rect(-width, 13*height/15, width*4, height/2);
  popMatrix();

  for (int i=0;i<midPoles.length;i++) {
    midPoles[i].move(speed/1.5);
    midPoles[i].display();
  }

//  if (keyPressed) {
//    if (keyCode == UP) {
//      zPos = lerp(oldZ, oldZ*1.25, 0.1);
//    }
//    if (keyCode == DOWN) {
//      zPos = lerp(oldZ, oldZ*.9, 0.1);
//    }
//    if (keyCode == LEFT) {
//      speed -= .075;
//      if (cam.location.x <= -width/3) {
//        cam.kill();
//      }
//      else {
//        cam.applyForce(backward);
//      }
//    }
//    if (keyCode == RIGHT) {
//      speed += .075;
//      if (cam.location.x >= width*1.5) {
//        cam.kill();
//      }
//      else {
//        cam.applyForce(forward);
//      }
//    }
//  }

  if (cam.location.x >= -width/3 && cam.location.x <= width*1.5) {
    PVector f = forward.get();
    f.mult(xFactor);
    cam.applyForce(f);
  }

  if (cam.location.x < -width/3) {
    cam.location.x = -width/3;
    cam.kill();
  }

  if (cam.location.x > width*1.5) {
    cam.location.x = width*1.5;
    cam.kill();
  }
  
  speed = speed+speedInc;
  speed = constrain(speed, 25, 50);

  xPos = cam.view();

  zPos = lerp(zPos, zoom, 0.1);
  zPos = constrain(zPos, 15, 65);
  zoomL = zoom;
  float zoomEffect = 130 - zPos*2;  
  cam.update();
  cam.setPos(zoomEffect, zPos);

  for (int i=0;i<frontPoles.length;i++) {
    frontPoles[i].move(speed);
    frontPoles[i].display();
  }
  // Set and send messages about train's position to Max/MSP
  if (zPos > 30) {
    xPos = constrain(xPos, -450, width*1.5);
    X.clearArguments();
    X.add( xPos );
  }
  else {
    xPos = constrain(xPos, width/4, width);
    X.clearArguments();
    X.add( 0 );
  }
  Z.clearArguments();
  Z.add( zPos );
  oscP5.send(X, myRemoteLocation);
  oscP5.send(Z, myRemoteLocation);

  a.display();
}

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    myString = trim(myString);

    // split the string at the commas
    // and convert the sections into integers:
    int sensors[] = new int[2];
    sensors = int(split(myString, ','));

    if (sensors.length > 1) {
      for (int sensorNum = 0; sensorNum < 2; sensorNum++) {
        println("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
      }
      // add a linefeed after all the sensor values are printed:
      //      println();

      // make sure there are two values before you use them:
      if (sensors.length > 1) {  
        zoom = map(sensors[0], 820, 260, 15, 65);
        xPos = map(sensors[1], 940, 380, -400, 1900);
        speedInc = map(sensors[1],940,380,-.2,.22);
        if (sensors[1] > 630 && sensors [1] < 690) {
          xFactor = 0.0;
          cam.velocity.mult(0.95);
        }
        else {
          xFactor = map(sensors[1], 940, 380, -10, 10)/40;
        }
      }
    }
  }
}

