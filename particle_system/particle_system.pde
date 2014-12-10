/****************************
  
  A Simple Particle System
  by Alex Johnson
  
  This demo aims to emulate and re-create
  a simple particle system for demonstration
  purposes. 
  
  Using demo and code examples written
  by Benjamin of blog.datasingularity.com:
  http://blog.datasingularity.com/?p=335
  
  Original Source can be found here:
  http://processing.datasingularity.com/sketches/ParticlePhysicsTutorial_4/applet/
  
  Additional Inspiration taken from:
  https://github.com/alexjohnson505/swarm-navigation
  
  Written for CS4300 Computer Graphics
  Final Exam
   
 ****************************/


ArrayList particles;

int LIFESPAN = 100;

// global gravity
PVector acceleration =  new PVector(0f, 0.025);

void setup() {
 size(400, 400); 
 stroke(0);
 strokeWeight(3);
 fill(150);
 smooth();
 particles = new ArrayList();
}

void draw() {
  background(255);
  
  // Create on mouse movement
  if (abs(mouseX-pmouseX) > 0.0001) {
    particles.add(new Particle()); 
  } 
  
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = (Particle)particles.get(i);
  
    if(!p.exist()) {
      particles.remove(i);  
    }
  }  
}


public class Particle {
  PVector location;
  PVector velocity;
  int age;
  
  public Particle() {
      location = new PVector(mouseX, mouseY);
      
      //get velocity from direction and speed of mouse movement
      velocity = new PVector(mouseX-pmouseX, mouseY-pmouseY);   

      age = 0;
  }
 
  public boolean exist() {
     velocity.add(acceleration);
     location.add(velocity);
     ellipse(location.x, location.y, 10, 10); 
     
     if (age > LIFESPAN) {
       return false;
     }
     
     age++;
     return true;
  }
    
}


