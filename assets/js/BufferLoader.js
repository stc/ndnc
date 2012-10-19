/**
 * Class BufferLoader
 */

BufferLoader = function(source, url) {
  this.source_ = source;
  this.url_ = url;
  this.buffer_ = 0;
  this.request_ = 0;
}

BufferLoader.prototype.load = function() {
  // Load asynchronously
  var request = new XMLHttpRequest();
  request.open("GET", this.url_, true);
  request.responseType = "arraybuffer";
  this.request_ = request;

  
  var bufferLoader = this;
  
  request.onload = function() 
  { 
    bufferLoader.buffer = context.createBuffer(request.response, false);
    bufferLoader.source_.buffer = bufferLoader.buffer;
    console.log(loadCount);
    loadCount++;
    
    if (loadCount == NUM_OF_SOUNDS) finishLoad();
  }

  request.send();

  
}