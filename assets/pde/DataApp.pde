//---------------------------------------------------------------------------------------------------------------------------------------------    
//  Main Application


interface JavaScript
{
  void filterController(float[] controls);
  void getSpektra();
}

//  make the connection (passing as the parameter) with javascript
void bindJavascript(JavaScript js)
{
  javascript = js;
}

//  instantiate javascript interface
JavaScript javascript;
float pointerPosX, pointerPosY;

DataReader reader;
VerletDisplay verletdisplay;
Gui gui;

int NUMBER_OF_NODES;

String[] allDistances[];
String allSplit[][];

//  all values we need later for graphing
float[] distanceValues;
int distance_value_num;

//  check if loaded on startup
boolean loaded = true;

//---------------------------------------------------------------------------------------------------------------------------------------------    

void setup()
{
  size(screen.width,600);
  //  set number of nodes
  
  NUMBER_OF_NODES = 8;
  
  //reader = new DataReader();
  verletdisplay = new VerletDisplay();
  gui = new Gui();
}

//---------------------------------------------------------------------------------------------------------------------------------------------    

void draw()
{
  gui.showDefault();
  
  if(isLoaded==0)
  {
    gui.loadingAnimation();
  }
  if(isLoaded==1)
  {
    //gui.displayLogo();
    verletdisplay.draw();
    gui.displayLocation();
    gui.showIntroText();
    //  gui.displayInfo();
    //  gui.displaySelected();
    //  println(verletdisplay.getNodeDistances());

    pointerPosX = mouseX;
    pointerPosY = mouseY;

    if(javascript!=null)
    {
      //  control function for filters
      javascript.filterController(verletdisplay.getNodeDistances());
      //  control function for sound analysis
      javascript.getSpektra();
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------    

void finishedLoading()
{
  loaded = true;
}

//---------------------experimental------------------------------------------------------------------------------------------------------------    

void drawSpektra(int[] sp)
{
  for (int i=0; i<sp.length; i++)
  {
    fill(100,100);
    rect(i/2+30,height-31,1,-sp[i]/4);
  }
}

void keyPressed()
{
  if(key=='p')
  {
   reader.getNextRow(); 
  }
  if(key=='o')
  {
    reader.getPreviousRow();
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------    

void mousePressed()
{
  verletdisplay.pressed();
}

void mouseDragged()
{
  verletdisplay.dragged();
}

void mouseReleased()
{
  verletdisplay.released();
}

