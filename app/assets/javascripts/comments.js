$(document).on('click', '[data-comment="reply"]', function(event){
  event.preventDefault();
  $(this).parent().children('[data-comment="form"]').toggleClass('hidden').find('[name="comment[body]"]').focus();
});
