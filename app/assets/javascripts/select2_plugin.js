$(document).on('page:change', function() {
  $('[data-input="select2"]').each(function() {
    var $this = $(this),
        defaultOptions = {
        },
        data = $this.data('options'),
        options = $.extend({}, defaultOptions, data);

    $(this).select2(options);
  });
});
