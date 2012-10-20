var context = null;
var loadCount = 0;
var NUM_OF_SOUNDS;
var sources = new Array();
var filters = new Array();
var volumeNodes = new Array();
var audioBuffers = new Array();

var filterValues = [10,10,10,10,10,10,10,10,10,10];
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
            
    } else 
    {
            alert('Web Audio API is not supported in this browser. \nPlease use latest version of Google Chrome \nor go and drink some tea');
            throw new Error('AudioContext not supported. :(');
    }
            NUM_OF_SOUNDS = 8;
           
            urls = ['./sounds/helsinki/01.mp3',
                    './sounds/helsinki/02.mp3',
                    './sounds/helsinki/03.mp3',
                    './sounds/helsinki/04.mp3',
                    './sounds/helsinki/05.mp3',
                    './sounds/helsinki/07.mp3',
                    './sounds/helsinki/08.mp3',
                    './sounds/helsinki/09.mp3'];
    
    analyser = context.createAnalyser();
    console.log("inited");
}

 
function stopSound() 
{
 // for(var i=0; i< NUM_OF_SOUNDS; i++)
    //if (_sources[i]) 
    //{
    //	_sources[i].noteOff(0);
  	//}
}

function playSound() 
{ 
    for (var i=0; i< NUM_OF_SOUNDS; i++)
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
        sources[i].connect(volumeNodes[i]);
        volumeNodes[i].connect(filters[i]);
       	filters[i].connect(context.destination);
        filters[i].connect(analyser);
        sources[i].noteOn(0);
    }      
}

function initSound(arrayBuffer, i) 
{
  
  context.decodeAudioData(arrayBuffer, function(buffer) 
  {
    audioBuffers[i] = buffer;
    loadCount++;
    console.log("loading: " + loadCount);
    if(loadCount==NUM_OF_SOUNDS)finishLoad();
  }, function(e) {
    console.log('Error decoding', e);
  });
}
  
// Loading via xhr2: loadSoundFile('filename.wav');

function loadSoundFile(i) 
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


//	set filters
function setFilters(controlArray)
    {
       if(controlArray.length>1) 
        {
                for(var i=0;i<NUM_OF_SOUNDS;i++) 
                { 
                    filters[i].frequency.value = 6000 - parseFloat(controlArray[i+1])*30; 
                }
             
        }
    }




















