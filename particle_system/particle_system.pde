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
  smooth();
}

void draw() {
  background(255);
  
  // Create particles on mouse movement
  if (abs(mouseX-pmouseX) > 0.0001) {
    
    // The initial position, initial velocity,
    // initial size, initial color, initial transparency,
    // lifetime, and mass can be set at creation.
    
    // Current position
    PVector position = new PVector(mouseX, mouseY);
    
    // Velocity is determined by the velocity of the mouse
    PVector velocity = new PVector(mouseX-pmouseX, mouseY-pmouseY);
    
    // Diameter
    float size = 12;
    
    // Color
    color colour = color(100); 
    
    // Opacity
    float transparency = 255;
    
    // Lifespan
    int lifetime = LIFESPAN;
    
    // Random Mass
    float mass = random(0, 2);

    system.add(new Particle(position, velocity, size, colour, transparency, lifetime, mass)); 
  }
  
  system.update();
}

// Represent a system/group of particles
public class System {
  ArrayList particles;
  int lifespan;
  
  System(){
     particles = new ArrayList();
     lifespan = 100;
  }
  
  // Add new particles
  void add(Particle p){
    particles.add(p);
  }
  
  // 'Game Tick' -> Update objects
  void update(){
    
    // iterate through particles
    for (int i = particles.size()-1; i >= 0; i--) {
    
      // Extract one particle at a time
      Particle p = (Particle)particles.get(i);
    
      if(!p.update()) {
        particles.remove(i);  
      }
    
      p.draw();
    }
  }
  
}

// Represent a single particle in the system 
public class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  int age;        // Current Age
  int lifetime;   // Lifespan
  
  float size;
  color colour;
  float transparency;
  
  public Particle(PVector _position, PVector _velocity, float _size, color _color, float _transparency, int _lifetime, float _mass){
    
    // Position
    position = _position;
    
    // Velocity
    velocity = _velocity;
    
    // Acceleration. Make the system a little more "chaotic"
    // by multiplying a random wildcard to the gravity value.
    acceleration = new PVector(0f, gravity * _mass);
    
    size = _size;
    colour = _color;
    transparency = _transparency;
    lifetime = _lifetime;
    
    // newborn particle
    age = 0;
  }
    
  
  public void draw(){
    fill(colour, transparency);
    ellipse(position.x, position.y, size, size);
  }
 
  public boolean update() {
    
    // Update velocity  
    velocity.add(acceleration);
    
    // Use velocity to determin the next location
    position.add(velocity);
     
     if (age > lifetime) {
       return false;
     } else {
       age++; 
       return true;
     }
  }
}


