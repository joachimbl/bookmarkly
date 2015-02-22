$(document).on('page:change', function() {
  $('[data-input="chosen"]').chosen({
    display_selected_options: false,
    allow_single_deselect: true,
    width: '200px'
  });
});
