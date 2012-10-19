
    var context;
    var loadCount = 0;
    var NUM_OF_SOUNDS;   //     number of sound nodes in the game
    var sources1 = new Array(); 
    var sources2 = new Array();  
    var buffers1 = new Array();
    var buffers2 = new Array();
    var volumeNodes1 = new Array();
    var filters1 = new Array();
    var volumeNodes2 = new Array();
    var filters2 = new Array();
    var filterValues = [60,10000,400,400,400,400,400,400,400,400];
    var urls;


    //    xPerimental
    var analyser;

    initSounds(); 

    // Step 1 - Initialise the Audio Context
    // There can be only one!

    function initSounds() 
    {

        console.log("init");
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
        
        if(sourcelocation == 0)
        {
            NUM_OF_SOUNDS = 10;
        }
        if(sourcelocation == 1)
        {
            NUM_OF_SOUNDS = 9;
        }
        if(sourcelocation == 2)
        {
            NUM_OF_SOUNDS = 8;
        }

        analyser = context.createAnalyser();
    }

    // Step 2: Load our Sound using XHR
    function startSound(index) 
    {
        console.log("startsound");
        //  populate 'urls' array with sounds based on selected mode 

        if(sourcelocation == 0)
        {
            urls = ['./sounds/0.mp3',
                    './sounds/1.mp3',
                    './sounds/2.mp3',
                    './sounds/3.mp3',
                    './sounds/4.mp3',
                    './sounds/5.mp3',
                    './sounds/6.mp3',
                    './sounds/7.mp3',
                    './sounds/8.mp3',
                    './sounds/9.mp3']; 
        }

        if(sourcelocation == 1)
        {
            urls = ['./sounds/london/1.mp3',
                    './sounds/london/2.mp3',
                    './sounds/london/3.mp3',
                    './sounds/london/4.mp3',
                    './sounds/london/5.mp3',
                    './sounds/london/6.mp3',
                    './sounds/london/8.mp3',
                    './sounds/london/9.mp3',
                    './sounds/london/10.mp3']; 
        }

        if(sourcelocation == 2)
        {
            urls = ['./sounds/helsinki/1.mp3',
                    './sounds/helsinki/2.mp3',
                    './sounds/helsinki/3.mp3',
                    './sounds/helsinki/4.mp3',
                    './sounds/helsinki/5.mp3',
                    './sounds/helsinki/7.mp3',
                    './sounds/helsinki/8.mp3',
                    './sounds/helsinki/9.mp3'];
        }

        
        // Note: this loads asynchronously
        var request = new XMLHttpRequest();
        console.log("requested");
        request.open("GET", urls[index], true);
        request.responseType = "arraybuffer";
        

        // Our asynchronous callback
        request.onload = function() 
        {
            var audioData = request.response;
            if(sourcelocation==1)
            {
                audioGraph1(audioData, index);
            }
            if(sourcelocation==2)
            {
                
                
                audioGraph2(audioData, index);
            }

            loadCount++;
            console.log(loadCount);

            if(loadCount==NUM_OF_SOUNDS) finishLoad();
        };
        request.send();
        
       // audioGraph(index);
    }

    // Finally: tell the source when to start
    function playSound(outputsound) 
    {
        // play the source now
        outputsound.noteOn(context.currentTime);
    }

    function stopSound(index) 
    {
        // stop the source now
        if(sourcelocation == 1)
        {
        sources1[index].noteOff(context.currentTime);
        }
        // stop the source now
        if(sourcelocation == 2)
        {
        sources2[index].noteOff(context.currentTime);
        }
    }

    // This is the code we are interested in
    function audioGraph2(audioData, index) 
    {
        
        console.log("audioGraph " + index);
        var lowPassFilter;

        sources2[index] = context.createBufferSource();
        buffers2[index] = context.createBuffer(audioData, true);
        sources2[index].buffer = buffers2[index];
        sources2[index].loop = true;
        
        volumeNodes2[index] = context.createGainNode();
        volumeNodes2[index].gain.value = 1;

        // Create our filter
        filters2[index] = context.createBiquadFilter();
        filters2[index].type = 0; // (Low-pass)

        // Specify parameters for the low-pass filter.
        filters2[index].frequency.value = filterValues[index]; // Cut off above n Hz
        
        sources2[index].connect(volumeNodes2[index]);
        volumeNodes2[index].connect(filters2[index]);
        filters2[index].connect(context.destination);

        filters2[index].connect(analyser);

        // Finally
        playSound(sources2[index]);
        
   }

    function audioGraph1(audioData, index) 
    {
        
        console.log("audioGraph " + index);
        var lowPassFilter;
        
        
        // Same setup as before
        sources1[index] = context.createBufferSource();
        buffers1[index] = context.createBuffer(audioData, true);
        sources1[index].buffer = buffers1[index];
        sources1[index].loop = true;

        volumeNodes1[index] = context.createGainNode();
        volumeNodes1[index].gain.value = 1;

        // Create our filter
        filters1[index] = context.createBiquadFilter();
        filters1[index].type = 0; // (Low-pass)

        // Specify parameters for the low-pass filter.
        filters1[index].frequency.value = filterValues[index]; // Cut off above n Hz

        sources1[index].connect(volumeNodes1[index]);
        volumeNodes1[index].connect(filters1[index]);
        filters1[index].connect(context.destination);
        
        filters1[index].connect(analyser);

        playSound(sources1[index]);

        
    }

    
    function setFilters(controlArray)
    {
       if(controlArray.length>1) 
        {
            if(sourcelocation==1)
            {
                for(var i=0;i<NUM_OF_SOUNDS;i++) 
                { 
                    filters1[i].frequency.value = 6000 - parseFloat(controlArray[i+1])*100; 
                }
            } 
            if(sourcelocation==2)
            {
                for(var i=0;i<NUM_OF_SOUNDS;i++) 
                { 
                    filters2[i].frequency.value = 6000 - parseFloat(controlArray[i+1])*100; 
                }
            }   
        }
    }


    


