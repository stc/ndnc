//--------------------------------------------------------------------------------------------------------------------------------------------
//  class for dynamic self-organizing particle system

import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
//---------------------------------------------------------------------------------------------------------------------------------------------    

class VerletDisplay
{
  //  set path for javascript to find dependencies
  var   VerletPhysics2D = toxi.physics2d.VerletPhysics2D;
  var   GravityBehavior = toxi.physics2d.behaviors.GravityBehavior;
  var   Vec2D = toxi.geom.Vec2D;
  var   Rect = toxi.geom.Rect;
  var   VerletParticle2D = toxi.physics2d.VerletParticle2D;
  var   VerletSpring2D = toxi.physics2d.VerletSpring2D;
      
  // Reference to physics world
  VerletPhysics2D physics;
  //  mouse selection
  VerletParticle2D selected=null;
  // squared snap distance for picking particles
  float snapDist=20*20;
  
  //  create an array for nodes (particles)
  VerletParticle2d[] nodeArray = new VerletParticle2d[NUMBER_OF_NODES];
 
  //rigidity (strength of connections)
  float str = params.strength;
  
  //  scale relative distances to screen
  float scaling = params.scale;

  //  mouse interaction
  Vec2D mousePos;
  AttractionBehavior mouseAttractor;

  //  all distances from selected node
  String str2return = "";
  Float[] tmpDistances = new String[NUMBER_OF_NODES];

  // store london info in arrays
  String[] londonLabels = new String[NUMBER_OF_NODES]; // names for labels
  int[] londonBg = new int[NUMBER_OF_NODES];        // background width for labels

  // store london info in arrays
  String[] helsinkiLabels = new String[NUMBER_OF_NODES]; // names for labels
  int[] helsinkiBg = new int[NUMBER_OF_NODES];        // background width for labels
 
//---------------------------------------------------------------------------------------------------------------------------------------------    

  VerletDisplay() 
  {
    //  Initialize london-specific label info

    londonLabels[0] = "sound of a separator";
    londonLabels[1] = "a beer keg swimming on Thames";
    londonLabels[2] = "sound of a chain";
    londonLabels[3] = "jumping on metal surfaces";
    londonLabels[4] = "pedestrian Tunnel under the Thames";
    londonLabels[5] = "raindrops on steel";
    londonLabels[6] = "a rusty boat";
    londonLabels[7] = "raindrops";
    londonLabels[8] = "raindrops";

    londonBg[0] = 140;
    londonBg[1] = 190;
    londonBg[2] = 140;
    londonBg[3] = 170;
    londonBg[4] = 210;
    londonBg[5] = 140;
    londonBg[6] = 140;
    londonBg[7] = 140;
    londonBg[8] = 140;

    //  Initialize helsinki-specific label info

    helsinkiLabels[0] = "chinese store at the railway station";
    helsinkiLabels[1] = "rush hour on the train";
    helsinkiLabels[2] = "skating in front of Kiasma";
    helsinkiLabels[3] = "metal stairs";
    helsinkiLabels[4] = "inside the Chapel of Silence";
    helsinkiLabels[5] = "leaves near the seashore";
    helsinkiLabels[6] = "metal barrell ( near a submarine, Suomenlinna Island )";
    helsinkiLabels[7] = "escaping Viking Line ( arrivers from the ship terminal )";
    
    helsinkiBg[0] = 200;
    helsinkiBg[1] = 190;
    helsinkiBg[2] = 150;
    helsinkiBg[3] = 120;
    helsinkiBg[4] = 210;
    helsinkiBg[5] = 200;
    helsinkiBg[6] = 300;
    helsinkiBg[7] = 300;
    

    // Initialize the physics
    physics=new VerletPhysics2D();
    physics.addBehavior(new GravityBehavior(new Vec2D(0,0)));
   
    // This is the center of the world
    Vec2D center = new Vec2D(width/2,height/2);
    // these are the worlds dimensions (50%, a vector pointing out from the center in both directions)
    Vec2D extent = new Vec2D(width/2,height/2);
   
    // Set the world's bounding box
    physics.setWorldBounds(Rect.fromCenterExtent(center,extent));
   
    for(int i = 0; i< NUMBER_OF_NODES; i++)
    {
     // nodeArray[i] = new VerletParticle2D(width/2+(i*10),height/2+(i*10)); 
      nodeArray[i] = new VerletParticle2D(random(width),random(height)); 
      
      physics.addParticle(nodeArray[i]);
      //  populate temporary distances array for nodes (to be used during runtime)
      tmpDistances[i] = 0;
    }

    // Lock a node in place if needed...
    // nodeArray[0].lock();

    //  make springs between nodes
    int tmpIndex;

    for(int firstNode=0; firstNode < physics.particles.length; firstNode++) 
    { 
      for(int secondNode = firstNode+1; secondNode<physics.particles.length; secondNode++) 
      {
        //  this line is reading spring lengths from external data
        //  VerletSpring2D spr = new VerletSpring2D(physics.particles[firstNode],physics.particles[secondNode],int(distanceValues[tmpIndex]),str);
        
        //  these are randomly generated springs
        VerletSpring2D spr = new VerletSpring2D(physics.particles[firstNode],physics.particles[secondNode],random(300),str);
        
        physics.addSpring(spr);
        tmpIndex++;
      }
    }  
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------    
 
  void draw() 
  {
    // set springlength using mouse
    // updateSpringsWithMouse();
    
    // set springlength using recorded data
    // updateStringsWithData();
    // println(londonLabels[0]);
    // set springlength using noise
    updateStringsWithNoise();

    //  update params based on gui
    updateWithGui()
    
    // Update the physics world
    physics.update();
   
    // draw all springs
    int springLen = physics.springs.length;
    for(int i =0;i < springLen; i++) 
    {
      VerletSpring2D s = physics.springs[i];
      strokeWeight(2);
      stroke(dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.5,dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.8,dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.3,200-dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.8);
      line(s.a.x,s.a.y,s.b.x,s.b.y);
    }

    // draw all particles
    int partLen = physics.particles.length;
    for(int i = 0;i<partLen; i++) 
    {
      VerletParticle2D p = physics.particles[i];

      noStroke();
      colorMode(HSB);
      fill(i*5+100,100,100,100);
      ellipse(p.x,p.y,25,25);
      colorMode(RGB);


      // selected particle in cyan, all others in black
      fill(0x99ffffff);
      stroke(p==selected ? 0xff00ffff : 0x44000000);
      ellipse(p.x,p.y,8,8);
      noStroke();
      fill(p==selected ? 0x334da9d3 : 0x00ffffff);
      ellipse(p.x,p.y,70,70);
    }
    
    //  indicate selectibility if mouse goes close to a point
    Vec2D mousePos=new Vec2D(mouseX,mouseY);
    int partLen = physics.particles.length;
    for(int i =0;i < partLen; i++) 
    {
       VerletParticle2D p=physics.particles[i];
      // if mouse is close enough, keep a reference to
      // the selected particle and lock it (becomes unmovable by physics)
      if (p.distanceToSquared(mousePos)<snapDist) 
      {
        //noStroke();
        stroke(0x334da9d3);
        ellipse(p.x,p.y,60,60);
      }
    }
    // display info on each node
    displayHelsinkiLabels();

    //  calculate & pass actual distances
    getNodeDistances();
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------    

  // check all particles if mouse pos is less than snap distance
  void pressed() 
  { 
    selected=null;
    Vec2D mousePos=new Vec2D(mouseX,mouseY);
    int partLen = physics.particles.length;
    for(int i =0;i < partLen; i++) 
    {
      VerletParticle2D p=physics.particles[i];
      // if mouse is close enough, keep a reference to
      // the selected particle and lock it (becomes unmovable by physics)
      if (p.distanceToSquared(mousePos)<snapDist) 
      {
        selected=p;
        selected.lock();
        break;
      }
    }
  }
  
  // only react to mouse dragging events if we have a selected particle
  void dragged() 
  {
    if (selected!=null) 
    {
      selected.set(mouseX,mouseY);
    }
  }
  
  // if we had a selected particle unlock it again and kill reference
  void released() 
  {
    if (selected!=null) 
    {
      selected.unlock();
      //selected=null;
    }
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------    

  void updateSpringsWithMouse()
  {
    int springLen = physics.springs.length;
    
      for(int i=0;i<springLen;i++)
      {
        VerletSpring2D s = physics.springs[i];
        s.setRestLength(mouseX);
      }


  }
  
  void updateWithGui()
  {
    int springLen = physics.springs.length;
    
      for(int i=0;i<springLen;i++)
      {
        VerletSpring2D s = physics.springs[i];
        s.setStrength(params.strength);
      }
      for(int i=0;i<springLen;i++)
      {
        VerletSpring2D s = physics.springs[i];
        s.setRestLength(params.scale*500);
      }
  }

  void updateStringsWithData()
  {  
    int springLen = physics.springs.length;
    for(int i =0;i < springLen; i++) 
    {
      VerletSpring2D s = physics.springs[i];
      //VerletSpring2D s = (VerletSpring2D) physics.springs.get(i);
      s.setRestLength(distanceValues[i]*scaling);
    }
    
    int partLen = physics.particles.length;
    for(int i = 0;i<partLen; i++) 
    {
      VerletParticle2D p= physics.particles[i];
      // clear velocities to avoid rotating and selforganizing
       p.clearVelocity();
     }
  }

  void updateStringsWithNoise()
  {
    float ratio = height / (float)width;
    float speedie = 0.0002f / 4;
    long ti = millis();
    PosX = (noise(ti * speedie * ratio)) * width;          
    PosY = (noise(12345 + ti * speedie)) * height;
    
    if(nodeArray[0]!=selected)
    {
      nodeArray[0].x = PosX;
      nodeArray[0].y = PosY;
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------    

  void displayLondonLabels()
  {
    noStroke();

    //  label positioning from node center
    int offSet = 20;
    textAlign(LEFT);

    for (int i=0; i< NUMBER_OF_NODES; i++)
    {
      fill(60,255-dist(mouseX,mouseY,nodeArray[i].x,nodeArray[i].y)*5);
      rect(nodeArray[i].x+offSet-6,nodeArray[i].y-12,londonBg[i],15,5,5);
      
      fill(255,255-dist(mouseX,mouseY,nodeArray[i].x,nodeArray[i].y)*5);
      text(londonLabels[i], nodeArray[i].x+offSet,nodeArray[i].y);
    }    
  }

  void displayHelsinkiLabels()
  {
    noStroke();

    //  label positioning from node center
    int offSet = 20;
    textAlign(LEFT);

    for (int i=0; i< NUMBER_OF_NODES; i++)
    {
      fill(60,255-dist(mouseX,mouseY,nodeArray[i].x,nodeArray[i].y)*5);
      rect(nodeArray[i].x+offSet-6,nodeArray[i].y-12,helsinkiBg[i],15,5,5);
      
      fill(255,255-dist(mouseX,mouseY,nodeArray[i].x,nodeArray[i].y)*5);
      text(helsinkiLabels[i], nodeArray[i].x+offSet,nodeArray[i].y);
    }    
  }
  
  //  get all node distances from selected particle
  String getNodeDistances()
  {
    for(int i=0;i<NUMBER_OF_NODES;i++)
    {
      if (selected==nodeArray[i])
      {
          //  str2return = allDistances[i][reader.currentRow];  // this is returning values based on the saved datalog file   
          //  this method gives back actual geometric distances based on the simulation
          for(int j = 0; j< NUMBER_OF_NODES; j++)
          {
            tmpDistances[j] = dist(nodeArray[i].x,nodeArray[i].y,nodeArray[j].x,nodeArray[j].y); 
          }
          str2return = "distances " + tmpDistances[0] + " " + tmpDistances[1] + " " + tmpDistances[2] + " " 
          + tmpDistances[3] + " " + tmpDistances[4] + " " + tmpDistances[5] + " " + tmpDistances[6] + " " 
          + tmpDistances[7] + " " + tmpDistances[8] + " " + tmpDistances[9] + " " + tmpDistances[10] + " ";
      }
    }
    return str2return;
  }
}
