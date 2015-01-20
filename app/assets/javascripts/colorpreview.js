var displayImage = function(img, color, provider){

  var width = 400,
    height = Math.ceil(img.height * (width / img.width));

  // Add the block to the results section.
  $('.demo .results').html(
    '<div class="background-wrapper"><div id="backgroundBlock"><span>' +
    provider+'</span></div></div>');

  // Create a wrapper.
  $('.background-wrapper').css({
    width: width + 20,
    height: height+ 20
  });
  // Build the actually placeholder.
  $('#backgroundBlock').css({
      background: color,
      width: width,
      height: height
  });
  // Center the text.
  $('#backgroundBlock span').css('padding-top', Math.floor(height/2)-10);

  // Animate the fade in.
  $('.background-wrapper').animate({opacity: 1}, 500);

  // Use Embedly display to resize the image, we add a timestamp in the demo o
  var src = $.embedly.display.resize(img.url,
      {query: {width:width, height:height}, key: $.embedly.defaults.key}) +
      '&_' +Math.floor(Math.random() * 1000);

  // Create the img element
  var elem = document.createElement('img');

  // Set up the onload handler.
  var loaded = false;
  var handler = function() {
    if (loaded) {
      return;
    }
    loaded = true;
    // Fade the image into view.
    $('#backgroundBlock img').animate({opacity: 1}, 1000);
  };

  // Add the attributes to the image.
  elem.onload = handler;
  elem.src = src;
  elem.style.display = 'block';
  // Place the image in the correct ID.
  document.getElementById('backgroundBlock').appendChild(elem);

  // If the image is already in the browsers cache call the handler.
  if (elem.complete) {
    handler();
  }
};

$('.demo-background .collapse .button').on('click', function(){
  // Grab the input.
  var url = $('.demo-background input').val();
  // Make the call to Embedly Extract
  $.embedly.extract(url)
    .progress(function(obj){
      // Grab images and create the colors.
      var img = obj.images[0],
        color = new Color(img.colors[0].color[0], img.colors[0].color[1], img.colors[0].color[2]);
      // Display the image inline.
      displayImage(img, color.hex, obj.provider_display);
    });
});
