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
 
// Settings
int LIFESPAN = 80;             // Game ticks before particles expire
int TOTAL = 100;               // Max allowed particles
float GRAVITY = 0.3;           // Downward pull on velocity
boolean VOLCANO_MODE = true;   // Set a single source of particles?
                               // Otherwise, use mouse for source. 

// Sketch size
int WIDTH  = 600;
int HEIGHT = 600;


// Init a particle system
System system;

void setup() {
  size(WIDTH, HEIGHT); 
  
  // Initialize a new particle system
  system = new System();
  
  noStroke();
  smooth();
}

void draw() {
  background(255);
  
  // Create particles
  if (abs(mouseX-pmouseX) > 0.0001 | VOLCANO_MODE) {
    
    // Add a particle to a system
    system.add();
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
  void add(){
 
    // The initial position, initial velocity,
    // initial size, initial color, initial transparency,
    // lifetime, and mass can be set at creation.
    
    PVector position = new PVector(0,0);
    PVector velocity = new PVector(0,0);
    color colour;
    float transparency;
    
    // If the sketch is set to "VOLCANO_MODE", we set
    // a single source in the center
    if (VOLCANO_MODE){
      
      // Create position from center
      // position = new PVector(WIDTH/2, HEIGHT/1.8);
      position = new PVector(mouseX, mouseY);
      
      // Create upward velocity, with random horizontal spread
      velocity = new PVector(random(-1.2, 1.2), -8); // Volcano
      // velocity = new PVector(-10, 0); // Hose

      // Color
      colour = color(255, 0, 0); 
      
      // Opacity
      transparency = random(50, 255);
      
    // OTHERWISE, we use the mouse to determing particle source
    } else {
      
      // Create position from mouse position
      position = new PVector(mouseX, mouseY);
      
      // Velocity is determined by the velocity of the mouse
      velocity = new PVector((mouseX-pmouseX) / 2, (mouseY-pmouseY) / 2);
      
      // Color
      colour = color(100); 
    
      // Opacity
      transparency = 255;
    }
  
    // Diameter
    float size = 12;
    
    // Lifespan
    int lifetime = LIFESPAN;
    
    // Random Mass
    float mass = random(.5, 2);

    Particle p = new Particle(position, velocity, size, colour, transparency, lifetime, mass); 
    
    // limit the total number of particles.
    if (particles.size() < TOTAL){
      particles.add(p);  
    }
  }
  
  // 'Game Tick' -> Update objects
  void update(){
    
    // iterate through particles
    // for (int i = particles.size()-1; i >= 0; i--) {
    for (int i = 0; i < particles.size(); i++){

      // Extract one particle at a time
      Particle p = (Particle)particles.get(i);
      
      // Check if particle has aged out.
      if(!p.alive()) {
        particles.remove(i);  
      }
      
      // Detect collisions
      // p.collisions();
      for (int j = 0; j < particles.size(); j++){
        Particle p2 = (Particle)particles.get(j);
        p.collision(p2);
      }
    
      // Render current particle
      p.draw();
      
      // Update position for next tick
      p.update();
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
    acceleration = new PVector(0f, GRAVITY * _mass);
    
    size = _size;
    colour = _color;
    transparency = _transparency;
    lifetime = _lifetime;
    
    // newborn particle
    age = 0;
  }
    
  // Draw shape
  public void draw(){
    fill(colour, transparency);
    ellipse(position.x, position.y, size, size);
  }
  
  // Update position and velocity
  public void update(){
    
    // Update velocity  
    velocity.add(acceleration);
    
    // Use velocity to determin the next location
    position.add(velocity);
  }
 
  // Is the particle still living?
  public boolean alive() {
    
     if (age > lifetime) {
       return false;
     } else {
       age++; 
       return true;
     }
  }
  
  // Check particle2 for a collision
  public boolean collision(Particle p2){
    
    // Calculate distance between 2 points    
    float distance = position.dist(p2.position);
    
    // Collison dectection has 2 cases to satisfy:
    //  a.) Are the two particles touching?
    //  b.) Are the two particles atleast 20 ticks old?
    //      This prevents particles are the coming out of
    //      the same source from acting up.
    
    if (distance < size && distance != 0 && age > 20){
      
      // Debug: Draw collision box
      // float hitX = (position.x + p2.position.x) / 2;
      // float hitY = (position.y + p2.position.y) / 2;
      // fill(250);
      // ellipse(hitX, hitY, 20, 20);//

      // On collision, "bouce" horizontally
      velocity = new PVector(velocity.x * -1, velocity.y, 0);
      
      // If a particle collides, change it's color to blue
      colour = color(150, 150, 250);
      
      return true;
    } else {
      return false;
    }
  }
}


