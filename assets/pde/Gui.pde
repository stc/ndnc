//-------------------------------------------------------------------------------------------------------------------------------------
//  class for handling visual interface, typography

class Gui
{
  PImage myMap;
  int fadeOut = 255;
  PFont largeCityfont;
  PFont smallCityfont;

//---------------------------------------------------------------------------------------------------------------------------------------------    

  Gui()
  {
    myMap = loadImage("./assets/pix/nanoMap.png")
    largeCityfont = createFont("Arial",48);
    normalFont = createFont("Arial",11);
    smallCityfont = createFont("Arial",9);
  }

//---------------------------------------------------------------------------------------------------------------------------------------------    

  void loadingAnimation()
  {
    fill(0);
    noStroke();
    rect(width/2-120,height/2-15,240,25,20,20,20,20);
    fill(255);
    textAlign(CENTER);
    textFont(normalFont);
      
    text("please wait... the sounds are loading",width/2,height/2);
    fill(100,200);
    text(NUM_OF_SOUNDS_TO_LOAD-loadCount + " sounds are remaining...",width/2,height/2+50);
    textAlign(LEFT);
  }
  
  void showDefault()
  {
      background(50);
      fill(200,100);
      textAlign(RIGHT);
      textFont(normalFont);
      fill(100,100);
      text("raw spectrum",width-30,height-15);
  }

  void showCityName(String n)
  {   
      textAlign(LEFT);
      fill(255,20);
      textFont(largeCityfont);
      text(n,10,50); 
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
      textFont(normalFont);
      
      text("Select a Node to hear its own sound...",width/2,height/2);
      textAlign(LEFT);
    }
  }

  void displayMap()
  {
    image(myMap,width-myMap.width,0);

    textAlign(RIGHT);
    textFont(normalFont);
    fill(150);
    text("SELECT CITY TO CHANGE LOCATION", width-30, myMap.height+15);

    selectCities("BUDAPEST",width-myMap.width+185,205);
    selectCities("KOSICE",width-myMap.width+195,190);
    selectCities("HELSINKI",width-myMap.width+195,90);
    selectCities("LONDON",width-myMap.width+80,170);
  }

  void selectCities (String name, int xPos, int yPos)
  {
    rectMode(CENTER);
    noStroke();
    //fill(0,255-dist(mouseX,mouseY,xPos,yPos)*2);
    //rect(xPos,yPos, 45,10);
    fill(0,255-dist(mouseX,mouseY,xPos,yPos)*3);
    rect(xPos,yPos, 50,10);
    rectMode(CORNER);
    textAlign(CENTER);
    textFont(smallCityfont);
    stroke(255,255-dist(mouseX,mouseY,xPos,yPos)*3);
    fill(255,255-dist(mouseX,mouseY,xPos,yPos)*3);
    text(name,xPos,yPos+3);
  }

  void pressed(int xPos, int yPos)
  {

    if(xPos>(width-myMap.width))
    {
        if(mouseY > 200 && mouseY < 250)
        {
          console.log("Budapest!");
          muteSounds();
          resetFilters();
          LOCATION = 2;
          NUM_OF_SOUNDS_TO_PLAY = 8;
          arrayOffset = 17;
          playSounds(17);        
          
        }

        if((mouseY > 185) && (mouseY < 200))
        {
          console.log("KOSICE!");
          muteSounds();
          resetFilters();
          LOCATION = 3;
          NUM_OF_SOUNDS_TO_PLAY = 9;
          arrayOffset = 25;
          playSounds(25);
          
        }

        if((mouseY > 165) && (mouseY < 180))
        {
          console.log("LONDON!");
          muteSounds();
          resetFilters();
          LOCATION = 0;
          NUM_OF_SOUNDS_TO_PLAY = 9;
          arrayOffset = 0;
          playSounds(0);
          
        }

        if(mouseY < 100 && mouseY > 70)
        {
          console.log("HELSINKI!");
          muteSounds();
          resetFilters();
          LOCATION = 1;
          NUM_OF_SOUNDS_TO_PLAY = 8;
          arrayOffset = 9;
          playSounds(9);
          
        }
      
    }  
  }

  void displaySelected()
  {
    String[] nodeName = split(verletdisplay.str2return, " ");
    fill(0,100);
    textFont(normalFont);
      
    text("You are listening the sounds of " + nodeName[0],10,height-50);
  }
}

