function setReverbImpulseResponse(url) {
  // Load impulse response asynchronously

  var request = new XMLHttpRequest();
  request.open("GET", url, true);
  request.responseType = "arraybuffer";

  request.onload = function() { 
    convolver.buffer = context.createBuffer(request.response, false);
  }
  
  request.send();
}

function loadBufferForSource(index, source, url) {
  

  // Load asynchronously

  var request = new XMLHttpRequest();
  request.open("GET", url, true);
  request.responseType = "arraybuffer";

  request.onload = function() {
    // Start playing the new buffer at exactly the next 4-beat boundary
    var currentTime = context.currentTime;

    // Add 120ms slop since we don't want to schedule too soon into the future.
    // This will potentially cause us to wait 4 more beats, if we're almost exactly at the next 4-beat transition.
    currentTime += 0.120;

    //  bogus variables
    var anchorTime = 20;
   // var source1, source2;

    var tempo = 120;
    var delta = currentTime - anchorTime;
    var deltaBeat = (tempo / 60.0) * delta;
    var roundedUpDeltaBeat = 4.0 + 4.0 * Math.floor(deltaBeat / 4.0);
    var roundedUpDeltaTime = (60.0 / tempo) * roundedUpDeltaBeat;
    var time = anchorTime + roundedUpDeltaTime;
    
    // Stop the current loop (when it gets to the next 4-beat boundary).
    source.noteOff(time);
    
    // Create a new source.
    var newSource = context.createBufferSource();
    if (source == sources[index]) newSource.connect(volumeNodes[index]);
   

    // Assign the buffer to the new source.
    newSource.buffer = context.createBuffer(request.response, false);

    // Start playing exactly on the next 4-beat boundary with looping.
    newSource.loop = true;
    newSource.noteOn(time);
    
    // This new source will replace the existing source.
    if (source == sources[index])  sources[index] = newSource;
  }

  request.send();  
}