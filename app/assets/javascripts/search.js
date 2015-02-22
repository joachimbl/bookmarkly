$(document).on('page:change', function() {
  var $searchForm = $('[data-form="search"]');

  $(document).on('change', '[data-select="search"]', function(event, params) {
    $searchForm.submit();
  });
});
