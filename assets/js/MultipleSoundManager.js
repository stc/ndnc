var context = null;
var loadCount = 0;
var sources = new Array();
var filters = new Array();
var volumeNodes = new Array();
var audioBuffers = new Array();

var filterValues =  [0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,
                    ];
var urls;
var analyser;

function initAll()
{
	if (typeof AudioContext == "function") 
    {
            context = new AudioContext();
    } 
    else if (typeof webkitAudioContext == "function") 
   {
            context = new webkitAudioContext();
            
   } 
    else 
    {
            alert('Web Audio API is not supported in this browser. \nPlease use latest version of Google Chrome \nor go and drink some tea');
            throw new Error('AudioContext not supported. :(');
    }      
            urls = [
                    './sounds/london/01.mp3',
                    './sounds/london/02.mp3',
                    './sounds/london/03.mp3',
                    './sounds/london/04.mp3',
                    './sounds/london/05.mp3',
                    './sounds/london/06.mp3',
                    './sounds/london/08.mp3',
                    './sounds/london/09.mp3',
                    './sounds/london/10.mp3',
                    './sounds/helsinki/01.mp3',
                    './sounds/helsinki/02.mp3',
                    './sounds/helsinki/03.mp3',
                    './sounds/helsinki/04.mp3',
                    './sounds/helsinki/05.mp3',
                    './sounds/helsinki/07.mp3',
                    './sounds/helsinki/08.mp3',
                    './sounds/helsinki/09.mp3',
                    './sounds/budapest/01.mp3',
                    './sounds/budapest/02.mp3',
                    './sounds/budapest/03.mp3',
                    './sounds/budapest/04.mp3',
                    './sounds/budapest/05.mp3',
                    './sounds/budapest/07.mp3',
                    './sounds/budapest/08.mp3',
                    './sounds/budapest/09.mp3',
                    './sounds/kosice/01.mp3',
                    './sounds/kosice/02.mp3',
                    './sounds/kosice/03.mp3',
                    './sounds/kosice/04.mp3',
                    './sounds/kosice/05.mp3',
                    './sounds/kosice/06.mp3',
                    './sounds/kosice/07.mp3',
                    './sounds/kosice/08.mp3',
                    './sounds/kosice/09.mp3'
                  ];         
    
    analyser = context.createAnalyser();
    console.log("inited");
}

 
function stopSounds() 
{
  for(var i=0; i< NUM_OF_SOUNDS_TO_LOAD; i++)
  {
      sources[i].noteOff(0);
  }
}

function muteSounds()
{
    for(var i=0; i< NUM_OF_SOUNDS_TO_LOAD; i++)
  {
      volumeNodes[i].gain.value = 0;
  }   
}

function loadSounds() 
{ 
    for (var i=0; i< NUM_OF_SOUNDS_TO_LOAD; i++)
    {
      console.log("creating sources...");
  	 //	create sources
      sources[i] = context.createBufferSource(); // Global so we can .noteOff() later.
      sources[i].buffer = audioBuffers[i];
      sources[i].loop = true;
      volumeNodes[i] = context.createGainNode();
       volumeNodes[i].gain.value = 1;

       //	create filters
       filters[i] = context.createBiquadFilter();
       filters[i].type = 0; // (Low-pass)
       filters[i].frequency.value = filterValues[i]; // Cut off above n Hz
        
        //	connections
        sources[i].connect(filters[i]);
        

        filters[i].connect(volumeNodes[i]);
        volumeNodes[i].gain.value = 0;
       	

        volumeNodes[i].connect(context.destination);
        volumeNodes[i].connect(analyser);
        //sources[i].noteOn(0);
    }       
}

function playSounds(offset)
{
  for (var i=offset; i< offset + NUM_OF_SOUNDS_TO_PLAY; i++)
    {
        //sources[i].noteOn(0);
        sources[i].noteOn(0);
        volumeNodes[i].gain.value = 0.8;
    }
}

function initSound(arrayBuffer, i) 
{
  
  context.decodeAudioData(arrayBuffer, function(buffer) 
  {
    audioBuffers[i] = buffer;
    loadCount++;
    console.log("loading: " + loadCount);
    if(loadCount==NUM_OF_SOUNDS_TO_LOAD)finishLoad();
  }, function(e) {
    console.log('Error decoding', e);
  });
}
  
// Loading via xhr2: loadSoundFile('filename.wav');

function loadSoundFiles(i) 
{
   var request = new XMLHttpRequest();
   request.open('GET', urls[i], true);
   request.responseType = 'arraybuffer';
   request.onload = function(e) {  
   console.log("request loaded");
   initSound(e.target.response, i);
  };
  request.send();
  console.log("request sent");
}

function resetFilters()
{
  for (var i=0; i< NUM_OF_SOUNDS_TO_LOAD; i++)
  {
    filters[i].frequency.value = filterValues[i]; // Cut off above n Hz
  }
}


//	set filters
function setFilters(offset, controlArray)
    {
       if(controlArray.length>1) 
        {
                for(var i=offset;i< NUM_OF_SOUNDS_TO_PLAY+offset;i++) 
                { 
                    filters[i].frequency.value = 6000 - parseFloat(controlArray[i-offset+1])*30; 
                }   
        }
    }




















