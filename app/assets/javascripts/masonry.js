$(document).ready(function(){
  var $container = $('#masonry-container');

  $container.imagesLoaded( function(){
    $container.masonry({
      itemSelector: '.box',
      isAnimated: !Modernizr.csstransitions,
    });
  });
});


jQuery(function($){
  var windowWidth = $(window).width();

  $(window).resize(function() {
      if(windowWidth != $(window).width()){
      location.reload();
      return;
      }
  });
});
