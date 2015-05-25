$(document).on('page:change', function() {
  init_masonry();
});

function init_masonry(){
  var $container = $('#masonry-container');

  $container.imagesLoaded( function(){
    $container.masonry({
      itemSelector: '.box',
      isAnimated: true
    });
  });
}

$(window).resize(function () {
  init_masonry();
});
