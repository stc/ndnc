//-------------------------------------------------------------------------------------------------------------------------------------
//  class for reading log data from external file

class DataReader
{
  int currentRow = 0;

//---------------------------------------------------------------------------------------------------------------------------------------------    

  DataReader()
  {
    allDistances = new String[NUMBER_OF_NODES][];
    allSplit = new String[NUMBER_OF_NODES][];
    
    for(int i=0; i< NUMBER_OF_NODES; i++)
    {
      //  read in all files
      allDistances[i] = loadStrings("data/distances_" + i + ".txt");
    
      //  split & prepare all files
      allSplit[i] = split(allDistances[i][currentRow],' ');
    
      //  create array for useful distances for later graphing
      distance_value_num += (NUMBER_OF_NODES-1) - i; 
    }
    
    distanceValues = new float[distance_value_num];
    mapValues();
  }

//---------------------------------------------------------------------------------------------------------------------------------------------    

  void getNextRow()
  {
      currentRow ++;
      if(currentRow > allDistances[0].length-1) currentRow = 0;
      readRow(currentRow);
  }
    
  void getPreviousRow()
  {
      currentRow --;
      if(currentRow < 0) currentRow = allDistances[0].length-1;
      readRow(currentRow);
  }
  
  void readRow(int index)
  {
    for(int i=0; i< NUMBER_OF_NODES; i++)
    {
      //  split & prepare all files
      if(allDistances[i][index]!=null)allSplit[i] = split(allDistances[i][index],' ');
    }
    mapValues();
  }

  void mapValues()
  {
    int index = 0;
    for(int i=0;i<NUMBER_OF_NODES;i++)
    {
      for (int j=i+2;j<NUMBER_OF_NODES+1;j++)
      {  
        distanceValues[index] = float(allSplit[i][j]);
      
        //println(distanceValues[index]);
        index ++;
      }
    }
  }
}