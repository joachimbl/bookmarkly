$(document).ready(function(){

  var columns    = 1,
  setColumns = function() { columns =
    $( window ).width() > 986 ? 4 :
    $( window ).width() > 769 ? 3 :
    $( window ).width() < 768 ? 1 :
    1; };

  setColumns();
  $( window ).resize( setColumns );

  var $container = $('#masonry-container');

  $container.imagesLoaded( function(){
    $container.masonry({
      itemSelector: '.box',
      isAnimated: !Modernizr.csstransitions,
      columnWidth:  function( containerWidth ) { return containerWidth / columns; }
    });
  });
});


