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
  VerletParticle2d[] nodeArray = new VerletParticle2d[MAX_NUMBER_OF_NODES];
 
  //rigidity (strength of connections)
  float str = params.strength;
  
  //  scale relative distances to screen
  float scaling = params.scale;

  //  mouse interaction
  Vec2D mousePos;
  AttractionBehavior mouseAttractor;

  PFont labelFont;

  //  all distances from selected node
  String str2return = "";
  Float[] tmpDistances = new String[MAX_NUMBER_OF_NODES];

  // store info for labels
  
  String[] textLabels = new String[NUM_OF_SOUNDS_TO_LOAD];
  int[] textLabelsBg = new int[NUM_OF_SOUNDS_TO_LOAD];

  /*
  String[] londonLabels = new String[NUMBER_OF_NODES]; // names for labels
  int[] londonBg = new int[NUMBER_OF_NODES];        // background width for labels

  // store helsinki info in arrays
  String[] helsinkiLabels = new String[NUMBER_OF_NODES]; // names for labels
  int[] helsinkiBg = new int[NUMBER_OF_NODES];        // background width for labels

  // store london info in arrays
  String[] budapestLabels = new String[NUMBER_OF_NODES]; // names for labels
  int[] budapestBg = new int[NUMBER_OF_NODES];        // background width for labels

  // store helsinki info in arrays
  String[] kosiceLabels = new String[NUMBER_OF_NODES]; // names for labels
  int[] kosiceBg = new int[NUMBER_OF_NODES];        // background width for labels
  */

 
//---------------------------------------------------------------------------------------------------------------------------------------------    

  VerletDisplay() 
  {

    labelFont = createFont("Arial",14);
    
    //  London labels

    textLabels[0] = "sound of a separator";
    textLabels[1] = "a beer keg swimming on Thames";
    textLabels[2] = "sound of a chain";
    textLabels[3] = "jumping on metal surfaces";
    textLabels[4] = "pedestrian Tunnel under the Thames";
    textLabels[5] = "raindrops on steel";
    textLabels[6] = "a rusty boat";
    textLabels[7] = "raindrops";
    textLabels[8] = "raindrops";

    textLabelsBg[0] = 140*1.2;
    textLabelsBg[1] = 190*1.2;
    textLabelsBg[2] = 140*1.2;
    textLabelsBg[3] = 170*1.2;
    textLabelsBg[4] = 210*1.2;
    textLabelsBg[5] = 140*1.2;
    textLabelsBg[6] = 140*1.2;
    textLabelsBg[7] = 140*1.2;
    textLabelsBg[8] = 140*1.2;
    
    //  Helsinki labels

    textLabels[9] = "chinese store at the railway station";
    textLabels[10] = "rush hour on the train";
    textLabels[11] = "skating in front of Kiasma";
    textLabels[12] = "metal stairs";
    textLabels[13] = "inside the Chapel of Silence";
    textLabels[14] = "leaves near the seashore";
    textLabels[15] = "metal barrell ( near a submarine, Suomenlinna Island )";
    textLabels[16] = "escaping Viking Line ( arrivers from the ship terminal )";

    textLabelsBg[9] = 200*1.2;
    textLabelsBg[10] = 190*1.2;
    textLabelsBg[11] = 150*1.2;
    textLabelsBg[12] = 120*1.2;
    textLabelsBg[13] = 210*1.2;
    textLabelsBg[14] = 200*1.2;
    textLabelsBg[15] = 300*1.2;
    textLabelsBg[16] = 300*1.2;
    
    //  Budapest labels
    
    textLabels[17] = "bycicle wheels";
    textLabels[18] = "overdriven communication tools";
    textLabels[19] = "emptying recycle bin";
    textLabels[20] = "metal sighs above the danube";
    textLabels[21] = "suburban railway lines";
    textLabels[22] = "sound of a saw";
    textLabels[23] = "dogs barking in the park";
    textLabels[24] = "tunnel";

    textLabelsBg[17] = 180*1.2;
    textLabelsBg[18] = 210*1.2;
    textLabelsBg[19] = 180*1.2;
    textLabelsBg[20] = 180*1.2;
    textLabelsBg[21] = 210*1.2;
    textLabelsBg[22] = 150*1.2;
    textLabelsBg[23] = 300*1.2;
    textLabelsBg[24] = 100*1.2;

    //  Kosice labels
    
    textLabels[25] = "fontaine in front of the campus";
    textLabels[26] = "kitchen at the campus";
    textLabels[27] = "chainsaw parade";
    textLabels[28] = "street construction";
    textLabels[29] = "screwdriver massachre";
    textLabels[30] = "elders singing in the park";
    textLabels[31] = "opening doors at the campus";
    textLabels[32] = "trashbin";
    textLabels[33] = "painting walls";

    textLabelsBg[25] = 210*1.2;
    textLabelsBg[26] = 190*1.2;
    textLabelsBg[27] = 160*1.2;
    textLabelsBg[28] = 170*1.2;
    textLabelsBg[29] = 180*1.2;
    textLabelsBg[30] = 200*1.2;
    textLabelsBg[31] = 200*1.2;
    textLabelsBg[32] = 120*1.2;
    textLabelsBg[33] = 150*1.2;
    

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
      stroke(dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.5,dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.8,dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.3,200-dist(s.a.x,s.a.y,s.b.x,s.b.y)*0.5);
      line(s.a.x,s.a.y,s.b.x,s.b.y);
    }

    // draw all particles
    int partLen = physics.particles.length;
    for(int i = 0;i<partLen; i++) 
    {
      VerletParticle2D p = physics.particles[i];

      noStroke();
      colorMode(HSB);
      
      if(LOCATION==0)fill(i*10+40,155,255);
      if(LOCATION==1)fill(i*10+90,155,255);
      if(LOCATION==2)fill(i*10+140,155,255);
      if(LOCATION==3)fill(i*10+190,155,255);
      
    if(selected!=null)
      {
        ellipse(p.x,p.y,20+(20-abs(dist(p.x,p.y,selected.x,selected.y))/15),20+(20-abs(dist(p.x,p.y,selected.x,selected.y))/15));
      }
      else
      {
          ellipse(p.x,p.y,20+(20-abs(dist(p.x,p.y,mouseX,mouseY))/20),20+(20-abs(dist(p.x,p.y,mouseX,mouseY))/20));
      
      }
      colorMode(RGB);

      // selected particle 
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
        noStroke();
        //stroke(0x334da9d3);
        fill(255,100);
        ellipse(p.x,p.y,60,60);
      }
    }
    
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

  void displayLabels(int labelOffset)
  {
    noStroke();

    //  label positioning from node center
    int offSet = 20;
    textAlign(LEFT);
    textFont(labelFont);

    for (int i=labelOffset; i< NUM_OF_SOUNDS_TO_PLAY+labelOffset; i++)
    {
      fill(11.2,255-dist(mouseX,mouseY,nodeArray[i-labelOffset].x,nodeArray[i-labelOffset].y)*5);
      rect(nodeArray[i-labelOffset].x+offSet-6,nodeArray[i-labelOffset].y-12,textLabelsBg[i],20,5,5);
      
      fill(255,255-dist(mouseX,mouseY,nodeArray[i-labelOffset].x,nodeArray[i-labelOffset].y)*5);
      text(textLabels[i], nodeArray[i-labelOffset].x+offSet,nodeArray[i-labelOffset].y+3);
    }    
  }

  //  get all node distances from selected particle
  String getNodeDistances()
  {
    for(int i=0;i<NUM_OF_SOUNDS_TO_PLAY;i++)
    {
      if (selected==nodeArray[i])
      {
          //  str2return = allDistances[i][reader.currentRow];  // this is returning values based on the saved datalog file   
          //  this method gives back actual geometric distances based on the simulation
          for(int j = 0; j< NUM_OF_SOUNDS_TO_PLAY; j++)
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
