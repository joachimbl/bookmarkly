$(document).on('page:change', function() {
  var $searchForm = $('[data-form="search"]'),
      $searchField = $('[data-input="search"]');

  $(document).on('change', '[data-select="search"]', function(event, params) {
    tags = $(this).val().join();
    $searchField.val(tags);
    $searchForm.submit();
  });
});
