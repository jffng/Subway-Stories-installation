class Cam {
   PVector acceleration, velocity, location;
   float mass;
   
   Cam(float x){
     location = new PVector(x,0);
     acceleration = new PVector(0,0);
     velocity = new PVector(0,0);
//     mass = 10;
   }

   void applyForce(PVector force){
    PVector f = force;
    acceleration.add(f);
   }
   
   void update(){
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    velocity.limit(3);
   }
   
   void kill(){
     velocity.mult(0);
   }
   
   void setPos(float _zoomEffect, float _zPos){
       location.limit(width*2);
       beginCamera();
       camera(location.x-_zoomEffect, (height/2.0)+_zPos, (height/3.0) / tan(PI*_zPos / 180.0), location.x, (height/2.0)+_zPos, 0, 0, 1, 0);
       endCamera();
   }
   
   float view(){
     return location.x;
   }
}
