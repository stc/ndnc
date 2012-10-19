//-------------------------------------------------------------------------------------------------------------------------------------
//  class for handling visual interface, typography

class Gui
{
  PImage myMap;
  int fadeOut = 255;
  PFont cityFont;

//---------------------------------------------------------------------------------------------------------------------------------------------    

  Gui()
  {
    myLogo = loadImage("./assets/pix/szovetsegLogo.png");
    cityFont = createFont("Arial",48);
    normalFont = createFont("Arial",11);
  }

//---------------------------------------------------------------------------------------------------------------------------------------------    

  void loadingAnimation()
  {
    fill(0);
    rect(width/2-120,height/2-15,240,25,20,20,20,20);
    fill(255);
    textAlign(CENTER);
    text("please wait... the sounds are loading",width/2,height/2);
    fill(100,200);
    text(NUM_OF_SOUNDS-loadCount + " sounds are remaining...",width/2,height/2+50);
    textAlign(LEFT);
  }
  
  void showDefault()
  {
      background(240);
      fill(200,100);
      textAlign(LEFT);
      textFont(cityFont);
      text("HELSINKI",30,40);
      textFont(normalFont);
      fill(100,100);
      text("raw spectrum",30,height-15);
  }

  void showIntroText()
  {
    fadeOut--;
    if(fadeOut>1)
    {
      fill(0,fadeOut);
      noStroke();
      rect(width/2-120,height/2-15,240,25,20,20,20,20);
      fill(255,fadeOut);
      textAlign(CENTER);
      text("Select a Node to hear its own sound...",width/2,height/2);
      textAlign(LEFT);
    }
  }

  void displayLogo()
  {
    image(myLogo,20,height-150);
  }

  void displayLocation()
  {
    fill(255);
      textAlign(LEFT);
      noStroke();
      fill(0,30);
      rect(width-420,height-55,440,36,2,2,2,2);
      fill(255);
      text("All sounds have been recorded at the sites of Helsinki (Finnland)" + "\n"
        + "in 2012, as part of the CityNoises Festival.", width-400,height-40);

    fill(180);
    textAlign(CENTER);
    text("Listen to the ever changing soundfield that had been created during the CityNoises festival, in London & Helsinki." + "\n" 
      + "If two nodes are getting closer, their sounds become more audible for each other...", width/2, height-40);
  }
  
  void displayInfo()
  {
    fill(0,100);
    text("You jumped at:  " + reader.currentRow + " seconds within the recorded data", 10,height-30);
    text("press 'p' to jump forward, press 'o' to jump backward", 10, height-10);
  }

  void displaySelected()
  {
    String[] nodeName = split(verletdisplay.str2return, " ");
    fill(0,100);
    text("You are listening the sounds of " + nodeName[0],10,height-50);
  }
}

