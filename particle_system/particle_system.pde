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

// Global Objects
ArrayList particles;

// Global Parameters
int LIFESPAN = 100;
float gravity = 0.3;

// Init var for a particle system
System system;

void setup() {
  size(600, 600); 
  
  // Initialize a new particle system
  system = new System();
  
  noStroke();
  fill(100);
  smooth();
}

void draw() {
  background(255);
  
  // Create particles on mouse movement
  if (abs(mouseX-pmouseX) > 0.0001) {
    system.add(new Particle()); 
  }
  
  system.update();
}

// Represent a system/group of particles
public class System {
  ArrayList particles;
  int lifespan;
  PVector acceleration;
  
  System(){
     particles = new ArrayList();
     lifespan = 100;
     acceleration = new PVector(0f, gravity);
  }
  
  // Add new particles
  void add(Particle p){
    particles.add(p);
  }
  
  void update(){
    
    // iterate through particles
    for (int i = particles.size()-1; i >= 0; i--) {
    
      // Extract one particle at a time
      Particle p = (Particle)particles.get(i);
    
      if(!p.update(acceleration)) {
        particles.remove(i);  
      }
    
      p.draw();
    }
  }
  
}

// Represent a single particle in the system 
public class Particle {
  PVector location;
  PVector velocity;
  int age;
  
  public Particle() {
      location = new PVector(mouseX, mouseY);
      
      // Velocity is determined by the velocity of the mouse
      velocity = new PVector(mouseX-pmouseX, mouseY-pmouseY);   

      age = 0;
  }
  
  public void draw(){
      ellipse(location.x, location.y, 12, 12);
  }
 
  public boolean update(PVector acceleration) {
     velocity.add(acceleration);
     location.add(velocity);
     
     if (age > LIFESPAN) {
       return false;
     }
     
     age++;
     return true;
  }
    
}


